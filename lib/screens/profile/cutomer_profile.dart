import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/customer-model.dart';
import 'package:stylesyncapp/screens/bottombar.dart';
import 'package:stylesyncapp/screens/chat/chats_screen.dart';
import 'package:stylesyncapp/services/auth_services.dart';
import 'package:stylesyncapp/services/local_storage.dart';
import 'package:stylesyncapp/widgets/detail-item.dart';

class CustomerProfileScreen extends StatefulWidget {
  final Customer customer;

  const CustomerProfileScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  void handleLogout() async {
    try {
      final customerData = await SharedPrefsHelper.getCustomerData();

      if (customerData != null) {
        final token = customerData['token'];
        if (token != null) {
          await AuthService().logout(token);
        }
      }

      await SharedPrefsHelper.clearUserData();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.customer.name,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatsScreen(
                    currentUserId: widget.customer.id,
                    currentUserName: widget.customer.name,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.chat_rounded,
            ),
            color: Colors.white,
            iconSize: 18,
          )
        ],
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
                  backgroundImage: NetworkImage(widget.customer.imageUrl),
                  backgroundColor: const Color(0xFFFFE0B2).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.customer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D4C41),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.customer.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFCCBC),
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
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EBC90),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: handleLogout,
                  child: const Text(
                    'Logout',
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
        ),
      ),
    );
  }

  List<Widget> _buildDetailItems() {
    return [
      DetailItem(
        title: 'Age',
        value: widget.customer.age.toString(),
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Gender',
        value: widget.customer.gender.toString(),
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Contact',
        value: widget.customer.contact,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
      DetailItem(
        title: 'Email',
        value: widget.customer.email,
        titleColor: const Color(0xFF8D6E63),
        valueColor: const Color(0xFF6D4C41),
      ),
    ];
  }
}
