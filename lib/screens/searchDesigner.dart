import 'package:flutter/material.dart';

class SearchDesigner extends StatefulWidget {
  const SearchDesigner({super.key});

  @override
  State<SearchDesigner> createState() => _SearchDesignerState();
}

class _SearchDesignerState extends State<SearchDesigner> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Search your designer",
      ),
    );
  }
}
