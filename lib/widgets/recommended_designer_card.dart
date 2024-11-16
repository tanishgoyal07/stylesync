import 'package:flutter/material.dart';

class RecommendedDesignerCard extends StatelessWidget {
  final Map<String, dynamic> designerData;
  final VoidCallback onTap;

  const RecommendedDesignerCard({
    Key? key,
    required this.designerData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color(0xFFFFFDE7),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: designerData['imageUrl'] != null
                    ? NetworkImage(designerData['imageUrl'])
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designerData['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 158, 119, 107), // Pastel brown
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStringFromListOrString(designerData['expertCategory']),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 199, 68, 98), // Pastel pink
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStringFromListOrString(designerData['experiencedIn']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Avg. Cost',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '₨ ${designerData['averagePricing'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 106, 175, 110),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStringFromListOrString(dynamic value) {
    if (value == null) return 'N/A';
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }
}
