import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/profile/recommended_designer_profile.dart';
import 'package:stylesyncapp/widgets/recommended_designer_card.dart';

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
        title: const Text(
          'Recommended Designers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 119, 107),
      ),
      body: Column(
        children: [
          _UserPreferencesCard(userPreferences: userPreferences),
          Expanded(
            child: designers.isEmpty
                ? const Center(
                    child: Text(
                      'No recommendations found for you.',
                      style: TextStyle(color: Color(0xFF6D4C41)),
                    ),
                  )
                : ListView.builder(
                    itemCount: designers.length,
                    itemBuilder: (context, index) {
                      final designerData = designers[index]; 
                      return RecommendedDesignerCard(
                        designerData: designerData, 
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecommendedDesignerProfileScreen(designer: designerData),
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
                backgroundColor: const Color(0xFF8EBC90),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  color: Colors.white,
                ),
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
        color: const Color(0xFFFBD4D4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '• Your Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _preferenceItem('Usage', userPreferences['usage']),
                  _preferenceItem('Category', userPreferences['category']),
                  _preferenceItem(
                      'Article Type', userPreferences['articleType']),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          '• $title',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? value.toString() : 'N/A',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
