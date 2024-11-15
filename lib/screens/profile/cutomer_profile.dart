import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/customer-model.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';

class CustomerProfileScreen extends StatelessWidget {
  final Customer customer;

  const CustomerProfileScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          customer.name,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis, 
        ),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(customer.imageUrl),
                  backgroundColor: const Color(0xFFFFE0B2)
                      .withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D4C41), // Dark pastel brown for name
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Ensure single-line display
                ),
              ),
               const SizedBox(height: 8),
              Center(
                child: Text(
                  customer.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFCCBC), // Dark pastel brown for name
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
             
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFFFCCBC),
              ),
              const SizedBox(height: 10),
              ..._buildDetailItems(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailItems() {
    return [
      DetailItem(
        title: 'Age',
        value: customer.age,
        titleColor: const Color(0xFF8D6E63), 
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Contact',
        value: customer.contact,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Email',
        value: customer.email,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
    ];
  }
}
