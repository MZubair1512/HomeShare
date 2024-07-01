import 'package:flutter/material.dart';
import 'package:flutter_login/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  void _submitPersonalInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString("email");

    final personalInfo = {
      "fullName": fullNameController.text,
      "email": email,
      "phone": phoneController.text,
      "dateOfBirth": dobController.text,
      "residentialAddress": addressController.text,
      "city": cityController.text,
      "state": stateController.text,
      "postalCode": postalCodeController.text,
      "created_at": FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance
        .collection('users')
        .add(personalInfo)
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            ))
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register'),
            content: Text(error.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(fullNameController, TextInputType.text, "Full Name", Icons.person),
              SizedBox(height: 20),
              _buildTextField(phoneController, TextInputType.phone, "Phone Number", Icons.phone),
              SizedBox(height: 20),
              _buildTextField(dobController, TextInputType.datetime, "Date of Birth", Icons.calendar_today),
              SizedBox(height: 20),
              _buildTextField(addressController, TextInputType.text, "Residential Address", Icons.home),
              SizedBox(height: 20),
              _buildTextField(cityController, TextInputType.text, "City", Icons.location_city),
              SizedBox(height: 20),
              _buildTextField(stateController, TextInputType.text, "State/Province", Icons.map),
              SizedBox(height: 20),
              _buildTextField(postalCodeController, TextInputType.number, "Postal Code", Icons.local_post_office),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _submitPersonalInfo();
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, TextInputType keyboardType, String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            size: 20,
          ),
        ),
      ),
    );
  }
}
