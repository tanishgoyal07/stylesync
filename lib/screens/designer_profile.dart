import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/designer-model.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';

class DesignerProfileScreen extends StatelessWidget {
  final Designer designer;

  const DesignerProfileScreen({Key? key, required this.designer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(designer.name, style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal.shade800,
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
                  backgroundImage: NetworkImage(designer.imageUrl),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  designer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  designer.availability == "Yes" ? 'Available' : 'Not Available',
                  style: TextStyle(
                    fontSize: 16,
                    color: designer.availability == "Yes"
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              DetailItem(title: 'Age Group', value: designer.ageGroup),
              DetailItem(title: 'Expert Category', value: designer.expertCategory),
              DetailItem(
                title: 'Expert Sub-Category', 
                value: designer.expertSubCategory,
              ),
              DetailItem(title: 'Experienced In', value: designer.experiencedIn),
              DetailItem(
                title: 'Average Pricing',
                value: '₨ ${designer.averagePricing.toStringAsFixed(2)}',
              ),
              DetailItem(
                title: 'Total Customers Served',
                value: '${designer.totalCustomersServed}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
