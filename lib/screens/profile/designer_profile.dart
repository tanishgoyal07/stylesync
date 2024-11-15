import 'package:flutter/material.dart';

import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/screens/bottombar.dart';
import 'package:stylesyncapp/services/auth_services.dart';
import 'package:stylesyncapp/services/local_storage.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';

class DesignerProfileScreen extends StatefulWidget {
  final Designer designer;
  bool? isLoggedInDesigner;

  DesignerProfileScreen({
    super.key,
    required this.designer,
    this.isLoggedInDesigner,
  });

  @override
  State<DesignerProfileScreen> createState() => _DesignerProfileScreenState();
}

class _DesignerProfileScreenState extends State<DesignerProfileScreen> {
  void handleLogout() async {
    try {
      final designerData = await SharedPrefsHelper.getDesignerData();
      final token = designerData!['token'];
      if (token != null) {
        await AuthService().logout(token);
      }
      await SharedPrefsHelper.clearUserData();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.designer.name,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.designer.imageUrl),
                  backgroundColor: const Color(0xFFFFE0B2).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.designer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D4C41),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              widget.designer.email.isNotEmpty
                  ? const SizedBox(height: 4)
                  : const SizedBox(
                      height: 0,
                    ),
              widget.designer.email.isNotEmpty
                  ? Center(
                      child: Text(
                        widget.designer.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFFCCBC),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.designer.availability == "Yes"
                      ? 'Available'
                      : 'Not Available',
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.designer.availability == "Yes"
                        ? const Color(0xFFA5D6A7)
                        : const Color(0xFFFFABAB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFFFCCBC),
              ),
              const SizedBox(height: 10),
              ..._buildDetailItems(),
              const SizedBox(height: 20),
              widget.isLoggedInDesigner == true
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8EBC90),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: handleLogout,
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailItems() {
    return [
      DetailItem(
        title: 'Age Group',
        value: widget.designer.ageGroup,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Expert Category',
        value: widget.designer.expertCategory,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Expert Sub-Category',
        value: widget.designer.expertSubCategory,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Experienced In',
        value: widget.designer.experiencedIn,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Average Pricing',
        value: '₨ ${widget.designer.averagePricing.toStringAsFixed(2)}',
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Total Customers Served',
        value: '${widget.designer.totalCustomersServed}',
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
    ];
  }
}
