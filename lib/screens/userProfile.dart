import 'package:flutter/material.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/settings.dart';
import 'package:flutter_login/utils/apis/userInfo.dart';
import 'package:flutter_login/widgets/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic userData;
  String? userEmail;

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

    @override
  void initState() {
    super.initState();
    loadUserEmail();
    fetchUserDetailsAndUpdateState();
  }

@override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
     Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove email from shared preferences
    Navigator.push(context, MaterialPageRoute(builder: (contet)=>Login())); // Navigate to login widget
  }

    return userData ==null? CircularProgressIndicator(): SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  CircleAvatar(child: Text("${userData["fullName"].substring(0, 2)}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 33,color: const Color.fromARGB(255, 0, 0, 0)),),minRadius: 44,backgroundColor: const Color.fromARGB(255, 251, 238, 120),),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 35,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(100),
                  //       color: Colors.blue, // Example edit icon color
                  //     ),
                  //     child: const Icon(
                  //       Icons.keyboard_arrow_right,
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userData?['fullName'] ?? '',
              style: TextStyle(fontSize: 13,color: Colors.grey),
            ),
            Text(
              userData?['email'] ?? '',
              style: TextStyle(fontSize: 13,color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// -- BUTTON
            // SizedBox(
            //   width: 200,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigate to update profile screen
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue, // Example button color
            //       shape: const StadiumBorder(),
            //     ),
            //     child: const Text('Edit Profile'),
            //   ),
            // ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            /// -- MENU
            ProfileMenuWidget(title: 'Settings', icon: Icons.settings, onPress: () {
               Navigator.push(context, MaterialPageRoute(builder: (contet)=>SettingsPage())); 
            },subtitle: "none",),
            ProfileMenuWidget(title: 'State / City', icon: Icons.location_city,subtitle: "${userData["state"]} / ${userData["city"]}", onPress: () {}),
            ProfileMenuWidget(title: 'My Address', icon: Icons.location_city,subtitle: "${userData["residentialAddress"]}", onPress: () {}),
            const Divider(),
            const SizedBox(height: 10),
            ProfileMenuWidget(title: 'Terms And Policy', icon: Icons.keyboard_arrow_right, onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (contet)=>TermsAndConditionsPage())); 
            },subtitle: "none",),
            ProfileMenuWidget(title: 'Logout', icon: Icons.keyboard_arrow_right, textColor: Colors.red, endIcon: false,subtitle: "none", onPress: () {
              logout();
              // Implement logout functionality
            }),
          ],
        ),
      );
  }
}


  
class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.color
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var iconColor = Color.fromARGB(255, 253, 233, 56) ; // Example icon color based on theme

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
      subtitle: subtitle!="none"? Text("$subtitle",style: TextStyle(fontSize: 9),) : null,
    );
  }
}
