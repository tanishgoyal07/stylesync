import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/auth/signup_screen.dart';
import 'package:stylesyncapp/services/local_storage.dart';

late Map<String, dynamic> loggedInUserData;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  
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
          loggedInUserData = customerData;
          isLoggedIn = true;
        });
      } else {
        final designerData = await SharedPrefsHelper.getDesignerData();
        if (designerData != null) {
          setState(() {
            loggedInUserData = designerData;
            isLoggedIn = true;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8D9A3), // Light pastel green background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            const Color.fromARGB(255, 158, 119, 107), // White app bar
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'StyleSync',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color for contrast on white background
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: isLoggedIn
            ? Image.asset(
                "assets/hompage_app.png",
                fit: BoxFit.cover,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/hompage_app.png",
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Are you looking for a dress or designing one?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Option Boxes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Option 1 Box
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(
                                  isDesigner: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 119, 107),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'I am a Designer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Option 2 Box
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(
                                  isDesigner: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 119, 107),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'I am a Customer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}