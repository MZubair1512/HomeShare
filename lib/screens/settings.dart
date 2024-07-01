import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressController.text = prefs.getString('residentialAddress') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      cityController.text = prefs.getString('city') ?? '';
      stateController.text = prefs.getString('state') ?? '';
      postalCodeController.text = prefs.getString('postalCode') ?? '';
    });
  }

  Future<void> _updateUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');

    final updatedData = {
      'residentialAddress': addressController.text,
      'phone': phoneController.text,
      'city': cityController.text,
      'state': stateController.text,
      'postalCode': postalCodeController.text,
    };

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update(updatedData);
      });
    });

    prefs.setString('residentialAddress', addressController.text);
    prefs.setString('phone', phoneController.text);
    prefs.setString('city', cityController.text);
    prefs.setString('state', stateController.text);
    prefs.setString('postalCode', postalCodeController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(addressController, TextInputType.text, 'Residential Address', Icons.home),
            SizedBox(height: 16),
            _buildTextField(phoneController, TextInputType.phone, 'Phone Number', Icons.phone),
            SizedBox(height: 16),
            _buildTextField(cityController, TextInputType.text, 'City', Icons.location_city),
            SizedBox(height: 16),
            _buildTextField(stateController, TextInputType.text, 'State/Province', Icons.map),
            SizedBox(height: 16),
            _buildTextField(postalCodeController, TextInputType.number, 'Postal Code', Icons.local_post_office),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, TextInputType keyboardType, String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[600]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 12),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
