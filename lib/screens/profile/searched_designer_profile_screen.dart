import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/screens/bottombar.dart';
import 'package:stylesyncapp/screens/chat/chat_with_designer_screen.dart.dart';
import 'package:stylesyncapp/services/auth_services.dart';
import 'package:stylesyncapp/services/image_service.dart';
import 'package:stylesyncapp/services/local_storage.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';
import 'package:stylesyncapp/widgets/portfolio_carousel.dart';

class SearchedDesignerProfileScreen extends StatefulWidget {
  final Designer designer;
  bool? isLoggedInDesigner;

  SearchedDesignerProfileScreen({
    super.key,
    required this.designer,
    this.isLoggedInDesigner,
  });

  @override
  State<SearchedDesignerProfileScreen> createState() =>
      _SearchedDesignerProfileScreenState();
}

class _SearchedDesignerProfileScreenState
    extends State<SearchedDesignerProfileScreen> {
  Future<Map<String, List<String>>>? portfolioImages;
  Map<String, dynamic>? userData;
  String currentUserId = "";
  String currentUserName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    portfolioImages = fetchPortfolioImages();
  }

  Future<void> _loadUserData() async {
    try {
      final customerData = await SharedPrefsHelper.getCustomerData();
      if (customerData != null) {
        setState(() {
          userData = customerData['customer'];
          currentUserId = userData?['id'];
          currentUserName = userData?['name'];
        });
      } else {
        final designerData = await SharedPrefsHelper.getDesignerData();
        if (designerData != null) {
          setState(() {
            userData = designerData['designer'];
            currentUserId = userData?['id'];
            currentUserName = userData?['name'];
          });
        }
      }
      print("heyy2");
      print(currentUserId);
      print(currentUserName);
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<Map<String, List<String>>> fetchPortfolioImages() async {
    final experienceList =
        widget.designer.experiencedIn.split(",").map((e) => e.trim()).toList();

    final Map<String, List<String>> imagesByCategory = {};
    for (var category in experienceList) {
      imagesByCategory[category] =
          await ImageService().fetchImagesForCategory(category);
    }
    return imagesByCategory;
  }

  void handleLogout() async {
    try {
      final designerData = await SharedPrefsHelper.getDesignerData();

      if (designerData != null) {
        final token = designerData['token'];
        if (token != null) {
          await AuthService().logout(token);
        }
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
              // Designer Info Section
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
              const Divider(color: Color(0xFFFFCCBC)),
              const SizedBox(height: 10),

              ..._buildDetailItems(),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFFFCCBC)),
              const SizedBox(height: 10),

              const Text(
                "Portfolio",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D4C41),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, List<String>>>(
                future: portfolioImages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Failed to load portfolio images");
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.entries.map((entry) {
                        return entry.value.isNotEmpty
                            ? PortfolioCarousel(
                                category: entry.key,
                                images: entry.value,
                              )
                            : Container();
                      }).toList(),
                    );
                  } else {
                    return const Text("No images found");
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
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
                  onPressed: () {
                    widget.isLoggedInDesigner == true
                        ? handleLogout()
                        : widget.designer.availability == 'Yes'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatWithDesignerScreen(
                                    currentUserId: currentUserId,
                                    currentUserName: currentUserName,
                                    otherUserId: widget.designer.id,
                                    otherUserName: widget.designer.name,
                                  ),
                                ),
                              )
                            : ();
                  },
                  child: Text(
                    widget.isLoggedInDesigner == true
                        ? 'Logout'
                        : widget.designer.availability == 'Yes'
                            ? 'Chat with Designer'
                            : 'Designer not available',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
