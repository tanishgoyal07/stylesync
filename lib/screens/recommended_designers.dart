import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/screens/designer_profile.dart';

class RecommendedDesigners extends StatelessWidget {
  final List<dynamic> designers;
  final Map<String, dynamic> userPreferences;

  const RecommendedDesigners({
    super.key,
    required this.designers,
    required this.userPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Recommended Designers'),
      ),
      body: Column(
        children: [
          _UserPreferencesCard(userPreferences: userPreferences),
          Expanded(
            child: designers.isEmpty
                ? const Center(child: Text('No recommendations found for you.'))
                : ListView.builder(
                    itemCount: designers.length,
                    itemBuilder: (context, index) {
                      final designerData = designers[index];
                      return DesignerCard(
                        designerData: designerData,
                        onTap: () {
                          final designer = Designer.fromMap(designerData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DesignerProfileScreen(designer: designer),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Go Back to Preferences',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserPreferencesCard extends StatelessWidget {
  final Map<String, dynamic> userPreferences;

  const _UserPreferencesCard({Key? key, required this.userPreferences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color.fromARGB(255, 210, 215, 230),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Your Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _preferenceItem('Usage', userPreferences['usage']),
                  _preferenceItem('Category', userPreferences['category']),
                  _preferenceItem('Article Type', userPreferences['articleType']),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _preferenceItem('Gender', userPreferences['gender']),
                   _preferenceItem('Age', userPreferences['age']),
                  _preferenceItem('Budget', '₨ ${userPreferences['amount']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _preferenceItem(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? value.toString() : 'N/A',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class DesignerCard extends StatelessWidget {
  final Map<String, dynamic> designerData;
  final VoidCallback onTap;

  const DesignerCard({
    Key? key,
    required this.designerData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: designerData['image_url'] != null
                    ? NetworkImage(designerData['image_url'])
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designerData['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      designerData['expert-category'] ?? 'No category',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      designerData['experienced-in'] ?? 'No expertise listed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Avg. Cost',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '₨ ${designerData['averagePricing'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
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
}
