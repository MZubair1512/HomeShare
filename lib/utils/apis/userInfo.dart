import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getUserDetailsFromFirestore() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final String? userEmail = pref.getString("email");


  if (userEmail == null) {
    print("Email not found in SharedPreferences.");
    return;
  }

  try {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      print("User details: $userData");
      return userData;

    } else {
      print("No user found with email: $userEmail");
      return false;
    }
  } catch (e) {
    print("Error fetching user details: $e");
    return false;
  }
}
