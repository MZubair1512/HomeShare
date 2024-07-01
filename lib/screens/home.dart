import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/screens/blogs.dart';
import 'package:flutter_login/screens/homebody.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/notification.dart';
import 'package:flutter_login/screens/orderHistory.dart';
import 'package:flutter_login/screens/portfolio.dart';
import 'package:flutter_login/screens/properties.dart';
import 'package:flutter_login/screens/userProfile.dart';
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


class Home extends StatefulWidget {
  const Home({Key? key,this.index}) : super(key: key);
  final index;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userEmail;
  dynamic userData;
  final List<ImageAsset> images = [
    ImageAsset(
      imagePath: 'https://www.fca-magazine.com/media/k2/items/cache/13321cae3113e8104a867b99921a855c_XL.jpg',
      projectName: 'Ocean View Apartments',
    ),
    ImageAsset(
      imagePath: 'https://media.bizj.us/view/img/12268784/green-street-apartments-4591-mcree-forest-park-southeast*900xx2126-1196-0-8.png',
      projectName: 'Abbottabad Heights',
    ),
    ImageAsset(
      imagePath: 'https://media.istockphoto.com/id/1483803643/photo/a-street-on-a-modern-brick-built-housing-development-in-the-uk.jpg?s=612x612&w=0&k=20&c=4utY6wmkDaaHoVTQ47wMNBKsi20gCm_vQF1r1vS-ibQ=',
      projectName: 'Margalla Hills Retreat',
    ),
  ];
  int _currentIndex = 0;

  late PageController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    // Replace with your actual screens
    HomeBody(),
    PropertySearch(),
    Portfolio(),
    NewsAndBlogsPage(),
    ProfileScreen(),
  ];

  


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
              // addProperties(context);
            },
            child: Image.asset('assets/icon.png', width: 44, height: 44),
          ),
        ),
        title: Text(
          "HomeShare",
          style: GoogleFonts.righteous(
            fontSize: 23,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle order icon tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseHistoryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: MoltenBottomNavigationBar(
      selectedIndex: _currentIndex,
      borderRaduis:BorderRadius.all(Radius.circular(32)),
      barHeight: 32,
      margin: EdgeInsets.only(bottom:5),
      domeHeight:10,
      domeCircleColor:Color.fromARGB(255, 244, 186, 115),
      domeCircleSize: 32,
      onTabChange: (clickedIndex) {
        setState(() {
          _currentIndex = clickedIndex;
        });
      },
      tabs: [
        MoltenTab(
          icon: Icon(Icons.home),
        ),
        MoltenTab(
          icon: Icon(Icons.search),
        ),
        MoltenTab(
          icon: Icon(Icons.ballot_rounded),
        ),
        MoltenTab(
          icon: Icon(Icons.newspaper),
        ),
        MoltenTab(
          icon: Icon(Icons.person),
        ),
      ],
   ),
      body:widget.index==null? _screens[_currentIndex]:_screens[widget.index],);
      
//        Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: CustomSearchTextField(),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0, bottom: 10),
//             child: Text(
//               "Top Features",
//               style: GoogleFonts.righteous(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 0, 0, 0),
//               ),
//             ),
//           ),
//           CarouselSlider(
//             items: images.map((imageAsset) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 5.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12.0),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.asset(
//                             imageAsset.imagePath,
//                             fit: BoxFit.cover,
//                           ),
//                           Container(
//                            decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.3), // Adjust the opacity as needed
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),),
//                           Positioned(
//                             bottom: 10,
//                             left: 10,
//                             child: Text(
//                               imageAsset.projectName,
//                               style: TextStyle(
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//             options: CarouselOptions(
//               autoPlay: true,
//               enlargeCenterPage: true,
//               aspectRatio: 16 / 9,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentIndex = index;
//                   _controller.animateToPage(
//                     index,
//                     duration: Duration(milliseconds: 150),
//                     curve: Curves.ease,
//                   );
//                 });
//               },
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             margin: EdgeInsets.all(3),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: Card(
//                       elevation: 3,
//                       child: CustomIconTile(
//                         iconData: Icons.location_city_sharp,
//                         text: "Properties",
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Card(
//                       elevation: 3,
//                       child: GestureDetector(
//                         onTap: ()=>addProperties(propertiesList, context),
//                         child: CustomIconTile(
//                           iconData: Icons.person,
//                           text: "Agents",
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Card(
//                       elevation: 3,
//                       child: CustomIconTile(
//                         iconData: Icons.newspaper,
//                         text: "News & Blogs",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0, bottom: 10),
//             child: Text(
//               "Available Shares",
//               style: GoogleFonts.righteous(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 0, 0, 0),
//               ),
//             ),
//           ),
//           Expanded(child: PropertyCards(limit: 5,)), // Assuming PropertyCards manages its own scrolling if necessary
//         ],
//       ),
//     );
//   }
// }

// class ImageAsset {
//   final String imagePath;
//   final String projectName;

//   ImageAsset({required this.imagePath, required this.projectName});
// }
  }}