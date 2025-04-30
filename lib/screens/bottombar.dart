import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/find_your_designer.dart';
import 'package:stylesyncapp/screens/homepage.dart';
import 'package:stylesyncapp/screens/product/product_screen.dart';
import 'package:stylesyncapp/screens/profile/profile_screen.dart';
import 'package:stylesyncapp/screens/searchDesigner.dart';
import 'package:stylesyncapp/screens/virtual_try_on.dart';

class BottomBar extends StatefulWidget {
  int passedIndex;
  BottomBar({
    super.key,
    this.passedIndex = 0,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    int selectedIndex = widget.passedIndex;
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static final List<Widget> _screens = <Widget>[
    const HomePage(),
    const FindYourDesigner(),
    const SearchDesignerScreen(),
    VirtualTryOnScreen(),
    const ProductScreen(),
    const MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 158, 119, 107),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.design_services,
              color: Colors.black,
            ),
            label: 'Find My Designer',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search Designer',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.door_sliding_outlined,
              color: Colors.black,
            ),
            label: 'Try-On',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag,
              color: Colors.black,
            ),
            label: 'Clothing',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'My Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: onTapped,
      ),
    );
  }
}
