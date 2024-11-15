import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/auth/login_screen.dart';
import 'package:stylesyncapp/services/auth_services.dart';

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
  bool isLoading = false;

  Future<void> handleSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
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
        title: Text(
            widget.isDesigner ? 'Designer Collaboration' : 'Custom Outfit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isDesigner
                  ? Column(
                      children: [
                        buildTextField('Name', 'name'),
                        buildTextField('Image', 'imageUrl'),
                        buildTextField('Email', 'email', isEmail: true),
                        buildTextField('Availability', 'availability'),
                        buildTextField('Age Group', 'ageGroup'),
                        buildTextField('Expert Category', 'expertCategory'),
                        buildTextField(
                            'Expert Sub-Category', 'expertSubCategory'),
                        buildTextField('Experience In', 'experiencedIn'),
                        buildTextField('Average Pricing', 'averagePricing',
                            isNumeric: true),
                        buildTextField(
                            'Total Customers Served', 'totalCustomersServed',
                            isNumeric: true),
                        buildPasswordField(),
                      ],
                    )
                  : Column(
                      children: [
                        buildTextField('Name', 'name'),
                        buildTextField('Image', 'imageUrl'),
                        buildTextField('Email', 'email', isEmail: true),
                        buildTextField('Contact', 'contact', isNumeric: true),
                        buildTextField('Age', 'age', isNumeric: true),
                        buildTextField('Gender', 'gender'),
                        buildPasswordField(),
                      ],
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : handleSignup,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Signup'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(isDesigner: widget.isDesigner),
                    ),
                  );
                },
                child: const Text('Login'),
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
      decoration: InputDecoration(labelText: label),
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
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password should be at least 6 characters';
        return null;
      },
      onSaved: (value) => formData['password'] = value,
    );
  }
}
