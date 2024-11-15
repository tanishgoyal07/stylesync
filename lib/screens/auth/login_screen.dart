import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/bottombar.dart';
import 'package:stylesyncapp/services/auth_services.dart';
import 'package:stylesyncapp/services/local_storage.dart';

class LoginScreen extends StatefulWidget {
  final bool isDesigner;
  const LoginScreen({super.key, required this.isDesigner});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> loginData = {};
  final AuthService authService = AuthService();
  bool isLoading = false;

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        final response = widget.isDesigner
            ? await authService.designerLogin(loginData)
            : await authService.customerLogin(loginData);

        if (widget.isDesigner) {
          await SharedPrefsHelper.saveDesignerData(response);
        } else {
          await SharedPrefsHelper.saveCustomerData(response);
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(),
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Email', 'email', isEmail: true),
              buildPasswordField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String key, {bool isEmail = false}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is required';
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
          return 'Invalid Email';
        return null;
      },
      onSaved: (value) => loginData[key] = value!,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        return null;
      },
      onSaved: (value) => loginData['password'] = value!,
    );
  }
}
