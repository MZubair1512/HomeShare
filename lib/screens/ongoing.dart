import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/utils/apis/userInfo.dart';
import 'package:flutter_login/widgets/addApi.dart';
import 'package:flutter_login/widgets/iconTile.dart';
import 'package:flutter_login/widgets/propertyList.dart';
import 'package:flutter_login/widgets/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_login/widgets/drawer.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:flutter_login/widgets/propertyList.dart';

class Ongoing extends StatefulWidget {
  const Ongoing({super.key});

  @override
  State<Ongoing> createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  late PageController _controller;
  int _currentIndex = 0;
  String? userEmail;
  dynamic userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
  void initState() {
    super.initState();
    loadUserEmail();
    fetchUserDetailsAndUpdateState();
    _controller = PageController(initialPage: _currentIndex); // Initialize PageController
  }

  Future<void> loadUserEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userEmail = pref.getString("email");
    });
  }

  Future<void> fetchUserDetailsAndUpdateState() async {
    Map<String, dynamic>? fetchedUserData = await getUserDetailsFromFirestore();
    print(fetchedUserData);
    if (fetchedUserData != null) {
      setState(() {
        userData = fetchedUserData;
      });
    }
}

Future<List<dynamic>> fetchOngoingUpwardProjects() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('profitRate', isGreaterThan: 0) // Projects with positive profit rate
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching ongoing upward projects: $e');
    return [];
  }
}

Future<List<dynamic>> fetchOngoingDownwardProjects() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('profitRate', isLessThan: 0) 
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching ongoing downward projects: $e');
    return [];
  }
}

Future<List<dynamic>> fetchCompletedProjects() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('completed', isEqualTo: true) 
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching completed projects: $e');
    return [];
  }
}

 @override
Widget build(BuildContext context) {
  return  userData == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        title: Text('Projects Listed'),
      ),
      body:SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Center(
                   child: CreditCardUi(
                                cardHolderFullName: "${userData["fullName"]}",
                                cardNumber: "${userData["bankAccountDetails"]}",
                                validThru: "XXXX",
                                topLeftColor: Colors.yellow.shade600,
                                bottomRightColor: Colors.orange.shade700,
                                cardProviderLogo: Image.asset("assets/icon.png"),
                   
                                ),
                 ),
                Text(
                  "Ongoing Projects (Upward)",
                  style: GoogleFonts.righteous(
            fontSize: 23,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
                ),
                SizedBox(height: 8.0),
                FutureBuilder(
                  future: fetchOngoingUpwardProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading projects: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No projects found.');
                    } else {
                      List<dynamic> projects = snapshot.data as List<dynamic>;
                      return Column(
                        children: projects.map((project) {
                          return ExpansionTile(
                            title: Text(project['projectName']),
                            children: [
                              ListTile(
                                title: Text('Builder: ${project['builderName']}'),
                              ),
                              // Add more details as needed
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  "Ongoing Projects (Downward)",
                 style: GoogleFonts.righteous(
            fontSize: 23,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
                ),
                SizedBox(height: 8.0),
                // Similar FutureBuilder for Downward Projects
                // Replace with your implementation
                FutureBuilder(
                  future: fetchOngoingDownwardProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading projects: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No projects found.');
                    } else {
                      List<dynamic> projects = snapshot.data as List<dynamic>;
                      return Column(
                        children: projects.map((project) {
                          return ExpansionTile(
                            title: Text(project['projectName']),
                            children: [
                              ListTile(
                                title: Text('Builder: ${project['builderName']}'),
                              ),
                              // Add more details as needed
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  "Completed (Rent Projections)",
                  style: GoogleFonts.righteous(
            fontSize: 23,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
                ),
                SizedBox(height: 8.0),
                // FutureBuilder for Completed Projects
                // Replace with your implementation
                FutureBuilder(
                  future: fetchCompletedProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading projects: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No projects found.');
                    } else {
                      List<dynamic> projects = snapshot.data as List<dynamic>;
                      return Column(
                        children: projects.map((project) {
                          return ExpansionTile(
                            title: Text(project['projectName']),
                            children: [
                              ListTile(
                              title: Text('Builder: ${project['builderName']}'),
                              ),
                              // Add more details as needed
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ));
}

}