import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/bottombar.dart';
import 'package:stylesyncapp/services/cloudinary_service.dart';
import 'package:stylesyncapp/services/product_services.dart';
import 'package:stylesyncapp/utils/pickImage.dart';

class ProductUploadingScreen extends StatefulWidget {
  const ProductUploadingScreen({super.key});

  @override
  State<ProductUploadingScreen> createState() => _ProductUploadingScreenState();
}

class _ProductUploadingScreenState extends State<ProductUploadingScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  final ProductService productService = ProductService();
  ImageSelector imageSelector = ImageSelector();
  bool isLoading = false;
  List<File> images = [];

  void selectImages(BuildContext context) async {
    final ImageSelector imageSelector = ImageSelector();
    final List<File> selectedImages =
        await imageSelector.selectMultipleImages();

    if (selectedImages.isNotEmpty) {
      setState(() {
        images = selectedImages;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${selectedImages.length} images selected")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No images selected")),
      );
    }
  }

  Future<void> handleUpload() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      List<String> uploadedImageUrls = [];

      try {
        if (images != null && images.isNotEmpty) {
          final cloudinaryService = CloudinaryService();
          uploadedImageUrls =
              await cloudinaryService.uploadMultipleImages(context, images);
          if (uploadedImageUrls.isEmpty) {
            throw Exception("Failed to upload images");
          }
        }
        formData['imageUrls'] = uploadedImageUrls;

        final response = await productService.uploadDesigns(formData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.green,
        ));

        _formKey.currentState?.reset();
        setState(() {
          formData.clear();
          images.clear();
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      formData.clear();
      images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Upload your Designs',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 119, 107),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Upload your beautiful designs here and showcase your creativity!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8EBC90),
                    ),
                  ),
                ),
                buildTextField('Your Name', 'designerName'),
                const SizedBox(height: 20),
                buildTextField('Item Category', 'category'),
                const SizedBox(height: 20),
                buildTextField('Item Type', 'articleType'),
                const SizedBox(height: 20),
                buildTextField('Item description', 'description'),
                const SizedBox(height: 20),
                buildTextField('Item price', 'price', isNumeric: true),
                const SizedBox(height: 20),
                buildImageUploadSection(context),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EBC90),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : handleUpload,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Upload My Designs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: clearForm,
                    child: const Text(
                      'Clear Form',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => selectImages(context),
          child: images.isEmpty
              ? Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Upload Images',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildTextField(String label, String key, {bool isNumeric = false}) {
  bool isDescriptionField = label == 'Item description';

  return TextFormField(
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.account_circle),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: label,
      hintText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: const Color(0xFFF8BBD0).withOpacity(0.2),
    ),
    keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    validator: (value) {
      if (value == null || value.isEmpty) return '$label is required';
      return null;
    },
    onSaved: (value) => formData[key] = value!,
    maxLines: isDescriptionField ? 5 : 1,
    minLines: isDescriptionField ? 3 : 1,
  );
}

}
