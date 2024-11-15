import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stylesyncapp/screens/auth/login_screen.dart';
import 'package:stylesyncapp/services/auth_services.dart';
import 'package:stylesyncapp/services/cloudinary_service.dart';
import 'package:stylesyncapp/utils/pickImage.dart';

class SignupScreen extends StatefulWidget {
  final bool isDesigner;
  const SignupScreen({super.key, required this.isDesigner});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  final AuthService authService = AuthService();
  ImageSelector imageSelector = ImageSelector();
  bool isLoading = false;
  File? image;

  void selectImage(BuildContext context) async {
    final File? selectedImage =
        await imageSelector.selectImage(ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No image selected")),
      );
    }
  }

  Future<void> handleSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      String? imageUrl;

      try {
        if (image != null) {
          final cloudinaryService = CloudinaryService();
          imageUrl = await cloudinaryService.uploadImage(context, image!);
          print(imageUrl);
          if (imageUrl == null || imageUrl.isEmpty) {
            throw Exception("Failed to upload profile image");
          }
        }
        formData['imageUrl'] = imageUrl ?? '';

        final response = widget.isDesigner
            ? await authService.createDesignerAccount(formData)
            : await authService.createCustomerAccount(formData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              isDesigner: widget.isDesigner,
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 158, 119, 107),
        title: Text(
          widget.isDesigner ? 'Designer Collaboration' : 'Custom Outfit',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              widget.isDesigner
                  ? Column(
                      children: [
                        Stack(
                          children: [
                            image != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(image!),
                                  )
                                : const CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        AssetImage("assets/defualt_avatar.png"),
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  selectImage(context);
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTextField('Name', 'name'),
                        const SizedBox(height: 20),
                        buildTextField('Email', 'email', isEmail: true),
                        const SizedBox(height: 20),
                        buildTextField('Availability', 'availability'),
                        const SizedBox(height: 20),
                        buildTextField('Age Group', 'ageGroup'),
                        const SizedBox(height: 20),
                        buildTextField('Expert Category', 'expertCategory'),
                        const SizedBox(height: 20),
                        buildTextField(
                            'Expert Sub-Category', 'expertSubCategory'),
                        const SizedBox(height: 20),
                        buildTextField('Experience In', 'experiencedIn'),
                        const SizedBox(height: 20),
                        buildTextField('Average Pricing', 'averagePricing',
                            isNumeric: true),
                        const SizedBox(height: 20),
                        buildTextField(
                            'Total Customers Served', 'totalCustomersServed',
                            isNumeric: true),
                        const SizedBox(height: 20),
                        buildPasswordField(),
                      ],
                    )
                  : Column(
                      children: [
                        Stack(
                          children: [
                            image != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(image!),
                                  )
                                : const CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        AssetImage("assets/defualt_avatar.png"),
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  selectImage(context);
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTextField('Name', 'name'),
                        const SizedBox(height: 20),
                        buildTextField('Email', 'email', isEmail: true),
                        const SizedBox(height: 20),
                        buildTextField('Contact', 'contact', isNumeric: true),
                        const SizedBox(height: 20),
                        buildTextField('Age', 'age', isNumeric: true),
                        const SizedBox(height: 20),
                        buildTextField('Gender', 'gender'),
                        const SizedBox(height: 20),
                        buildPasswordField(),
                      ],
                    ),
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
                  onPressed: isLoading ? null : handleSignup,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(isDesigner: widget.isDesigner),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color.fromARGB(255, 158, 119, 107),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String key,
      {bool isEmail = false, bool isNumeric = false}) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(isEmail ? Icons.email : Icons.account_circle),
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
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
          return 'Invalid Email';
        return null;
      },
      onSaved: (value) => formData[key] = value,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: 'Password',
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xFFF8BBD0).withOpacity(0.2),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password should be at least 6 characters';
        return null;
      },
      onSaved: (value) => formData['password'] = value,
    );
  }
}
