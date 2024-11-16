import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/product/product_listing_screen.dart';
import 'package:stylesyncapp/screens/product/product_uploading_screen.dart';
import 'package:stylesyncapp/services/local_storage.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  bool isDesigner = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final customerData = await SharedPrefsHelper.getCustomerData();
      if (customerData != null) {
        setState(() {
          isDesigner = false;
          userData = customerData['customer'];
        });
      } else {
        final designerData = await SharedPrefsHelper.getDesignerData();
        if (designerData != null) {
          setState(() {
            isDesigner = true;
            userData = designerData['designer'];
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return (isDesigner && userData != null)
        ? const ProductUploadingScreen()
        : const ProductListingScreen();
  }
}
