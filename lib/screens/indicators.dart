import 'package:flutter/material.dart';
import 'package:stylesyncapp/helpers/colors.dart';
import 'package:stylesyncapp/screens/bottombar.dart';

class BPage extends StatefulWidget {
  @override
  _BPageState createState() => _BPageState();
}

class _BPageState extends State<BPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;

  navigateToBottomBar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomBar(),
      ),
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            children: <Widget>[
              buildBackgroundPage("assets/indicators1.png"),
              buildBackgroundPage("assets/indicators2.png"),
              buildBackgroundPage("assets/indicators3.png"),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
              right: 20,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: navigateToBottomBar,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundPage(String image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: ColorSys.secoundary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    return List<Widget>.generate(
        3, (index) => _indicator(currentIndex == index));
  }
}
