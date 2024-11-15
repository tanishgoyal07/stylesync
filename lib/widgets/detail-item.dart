import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;

  const DetailItem({
    Key? key,
    required this.title,
    required this.value,
    required this.titleColor,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
