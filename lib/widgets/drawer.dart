import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/agents.dart';
import 'package:flutter_login/screens/home.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/ongoing.dart';
import 'package:flutter_login/screens/portfolio.dart';
import 'package:flutter_login/screens/properties.dart';
import 'package:flutter_login/screens/settings.dart';
import 'package:flutter_login/screens/whishlist.dart';
import 'package:flutter_login/widgets/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login/utils/apis/userInfo.dart'; // Import your API utilities here

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? userEmail;
  dynamic userData;

   Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove email from shared preferences
    Navigator.push(context, MaterialPageRoute(builder: (contet)=>Login())); // Navigate to login widget
  }

  @override
  void initState() {
    super.initState();
    loadUserEmail();
    fetchUserDetailsAndUpdateState();
  }

  Future<void> loadUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString("email");
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('dashboard');
                      // Handle dashboard tap
                    },
                    child: CircleAvatar(
                      minRadius: 40.0,
                      child: Text(userData?["fullName"]?.substring(0, 1).toUpperCase() ?? "?",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                      
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    userData?["fullName"] ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    userEmail ?? 'Loading...',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>Home())),
              child: drawerTile(
                title: 'Home',
                icon: Icons.home,
                routeName: 'Dashboard',
              ),
            ),
            Divider(color: Colors.grey[52]),

            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>Ongoing())),
              child: drawerTile(
                title: 'View Projects',
                icon:  Icons.category,
                routeName: 'SearchProperty',
              ),
            ),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>WishlistedPropertiesPage())),
            child:drawerTile(
              title: 'WhishList',
              icon: Icons.favorite,
              routeName: 'Favourites',
            ),),
            Divider(color: Colors.grey[52]),
             GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(index:2))),
            child:drawerTile(
              title: 'Portfolio',
              icon: Icons.person_2_rounded,
              routeName: 'SavedSearches',
            ),),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>AgentsListPage())),
            child:drawerTile(
              title: 'Agents',
              icon: Icons.people,
              routeName: 'Agents',
            ),),
            Divider(color: Colors.grey[52]),
            drawerTile(
              title: 'News and Blog',
              icon: Icons.article,
              routeName: 'NewsAndBlog',
            ),
            Divider(color: Colors.grey[52]),
            drawerTile(
              title: 'About Us',
              icon: Icons.info,
              routeName: 'AboutUs',
            ),
            Divider(color: Colors.grey[52]),
            drawerTile(
              title: 'Contact Us',
              icon: Icons.contact_phone,
              routeName: 'ContactUs',
            ),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>TermsAndConditionsPage())),
            child: drawerTile(
              title: 'Terms and Policies',
              icon: Icons.policy,
              routeName: 'TermsAndConditions',
            ),),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>SettingsPage())),
            child:drawerTile(
              title: 'Settings',
              icon: Icons.settings,
              routeName: 'Settings',
            ),),
            Divider(color: Colors.grey[52]),
            GestureDetector(
              onTap: ()=>logout(),
              child: drawerTile(
                title: 'Log Out',
                icon: Icons.logout,
                routeName: 'SignIn',
              ),
            ),
            Divider(color: Colors.grey[52]),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget drawerTile({required String title, required IconData icon, required String routeName}) {
    return Container(
      height: 40,
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, color: Colors.grey),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
