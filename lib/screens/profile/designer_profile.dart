import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';

class DesignerProfileScreen extends StatelessWidget {
  final Designer designer;

  const DesignerProfileScreen({Key? key, required this.designer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          designer.name,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis, // Truncate if the name is too long
        ),
        backgroundColor: const Color(0xFF8D6E63), // Pastel brown for AppBar
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
                  backgroundImage: NetworkImage(designer.imageUrl),
                  backgroundColor: const Color(0xFFFFE0B2)
                      .withOpacity(0.5), // Light pastel peach for background
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  designer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D4C41), // Dark pastel brown for name
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Ensure single-line display
                ),
              ),
              designer.email.isNotEmpty ? SizedBox(height: 4) : SizedBox(height: 0,),
              designer.email.isNotEmpty ? Center(
                child: Text(
                  designer.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFCCBC), // Dark pastel brown for name
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ) : Container(),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  designer.availability == "Yes"
                      ? 'Available'
                      : 'Not Available',
                  style: TextStyle(
                    fontSize: 16,
                    color: designer.availability == "Yes"
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
        value: designer.ageGroup,
        titleColor: const Color(0xFF8D6E63), 
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Expert Category',
        value: designer.expertCategory,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Expert Sub-Category',
        value: designer.expertSubCategory,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Experienced In',
        value: designer.experiencedIn,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Average Pricing',
        value: '₨ ${designer.averagePricing.toStringAsFixed(2)}',
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Total Customers Served',
        value: '${designer.totalCustomersServed}',
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
    ];
  }
}
