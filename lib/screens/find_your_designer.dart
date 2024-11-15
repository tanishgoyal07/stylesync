import 'package:flutter/material.dart';
import 'package:stylesyncapp/screens/recommended_designers.dart';
import 'package:stylesyncapp/services/recommendation_service.dart';

class FindYourDesigner extends StatefulWidget {
  const FindYourDesigner({super.key});

  @override
  State<FindYourDesigner> createState() => _FindYourDesignerState();
}

class _FindYourDesignerState extends State<FindYourDesigner> {
  final RecommendationService recommendationService = RecommendationService();
  final _formKey = GlobalKey<FormState>();

  String usage = 'Casual';
  String category = 'Topwear';
  String articleType = 'Dresses';
  String gender = 'Men';
  double age = 25;
  double amount = 1000;

  final List<String> usageOptions = [
    'Casual',
    'Formal',
    'Ethnic',
    'Sports',
    'Smart-Casual'
  ];

  final List<String> categoryOptions = [
    'Topwear',
    'Bottomwear',
    'Nightwear',
    'Loungewear',
    'Innerwear',
    'Saree',
    'Dress'
  ];

  final List<String> articleTypeOptions = [
    'Dresses',
    'Tshirts',
    'Trousers',
    'Tops',
    'Shirts',
    'Jeans',
    'Kurtas',
    'Jackets',
    'Shorts',
    'Saree'
  ];

  final List<String> genderOptions = ['Men', 'Women'];

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      usage = 'Casual';
      category = 'Topwear';
      articleType = '';
      gender = 'Men';
      age = 25;
      amount = 1000;
    });
  }

  Future<void> _submitPreferences() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> userPreferences = {
        'usage': usage,
        'category': category,
        'articleType': articleType,
        'gender': gender,
        'age': age,
        'amount': amount,
      };

      try {
        final response = await recommendationService
            .getRecommendedDesigners(userPreferences);
        if (response['status'] == 'success') {
          _resetForm();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedDesigners(
                designers: response['data'],
                userPreferences: userPreferences,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error fetching recommendations')),
          );
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Find My Designer',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 158, 119, 107), // Pastel brown
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildDropdownField('Usage', usageOptions, (value) {
                  setState(() {
                    usage = value!;
                  });
                }, usage),
                const SizedBox(height: 20),
                _buildDropdownField('Category', categoryOptions, (value) {
                  setState(() {
                    category = value!;
                  });
                }, category),
                const SizedBox(height: 20),
                _buildAutoCompleteField(),
                const SizedBox(height: 20),
                _buildAgeIncrementer(),
                const SizedBox(height: 20),
                _buildDropdownField('Gender', genderOptions, (value) {
                  setState(() {
                    gender = value!;
                  });
                }, gender),
                const SizedBox(height: 20),
                _buildBudgetSlider(),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63), // Pastel brown
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Find My Designer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      ValueChanged<String?> onChanged, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: initialValue,
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Please select a $label' : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor:
                const Color(0xFFF8BBD0).withOpacity(0.2), // Light pastel pink
          ),
        ),
      ],
    );
  }

  Widget _buildAutoCompleteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Article Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return articleTypeOptions.where((option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            setState(() {
              articleType = selection;
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Select or type your article type',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: const Color(0xFFF8BBD0).withOpacity(0.2),
              ),
              onSaved: (value) => articleType = value ?? '',
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter or select an article type'
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAgeIncrementer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Age',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundButton(Icons.remove, () {
              setState(() {
                if (age > 1) age--;
              });
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2)
                      .withOpacity(0.5), // Light pastel peach
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: const Color(0xFF8D6E63), width: 2), // Pastel brown
                ),
                child: Text(
                  '$age',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildRoundButton(Icons.add, () {
              setState(() {
                if (age < 100) age++;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onPressed) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF8D6E63), // Pastel brown
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Budget',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('₹${amount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        Slider(
          value: amount,
          min: 1000,
          max: 50000,
          divisions: 100,
          label: '₹${amount.toStringAsFixed(0)}',
          activeColor: const Color(0xFF8D6E63), // Pastel brown
          inactiveColor:
              const Color(0xFFFFE0B2).withOpacity(0.5), // Light pastel peach
          onChanged: (value) {
            setState(() {
              amount = value;
            });
          },
        ),
      ],
    );
  }
}
