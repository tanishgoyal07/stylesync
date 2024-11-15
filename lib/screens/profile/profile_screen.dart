import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/customer-model.dart';
import 'package:stylesyncapp/screens/auth/signup_screen.dart';
import 'package:stylesyncapp/screens/profile/cutomer_profile.dart';
import 'package:stylesyncapp/screens/profile/designer_profile.dart';
import 'package:stylesyncapp/services/local_storage.dart';

import '../../models/designer-model.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isLoading = true;
  bool isDesigner = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await SharedPrefsHelper.getCustomerData();
    print("heree");
    print(data);
    if (data == null) {
      final designerData = await SharedPrefsHelper.getDesignerData();
      setState(() {
        isDesigner = true;
        userData = designerData;
        isLoading = false;
      });
    } else {
      setState(() {
        isDesigner = false;
        userData = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                        color: Colors.brown[200],
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
                        color: Colors.brown[200],
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
          ],
        ),
      );
    }

    return isDesigner
        ? DesignerProfileScreen(designer: Designer.fromMap(userData ?? {}))
        : CustomerProfileScreen(customer: Customer.fromMap(userData ?? {}));
  }
}
