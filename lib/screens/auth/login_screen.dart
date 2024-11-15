import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/auth/signup_screen.dart';
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ),
        );

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Login',
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
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0xFFF8BBD0),
                  backgroundImage: AssetImage("assets/default_avatar.png"),
                ),
                const SizedBox(height: 20),
                buildTextField('Email', 'email', isEmail: true),
                const SizedBox(height: 20),
                buildPasswordField(),
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
                    onPressed: isLoading ? null : handleLogin,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Login',
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
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(
                              isDesigner: widget.isDesigner ? true : false,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Create new",
                        style: TextStyle(
                            color: Color.fromARGB(255, 158, 119, 107),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String key, {bool isEmail = false}) {
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
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Password",
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xFFF8BBD0).withOpacity(0.2),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        return null;
      },
      onSaved: (value) => loginData['password'] = value!,
    );
  }
}
