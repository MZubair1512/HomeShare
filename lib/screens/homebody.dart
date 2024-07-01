import 'package:flutter/material.dart';
import 'package:flutter_login/screens/agents.dart';
import 'package:flutter_login/screens/blogs.dart';

import 'package:flutter_login/screens/home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_login/screens/properties.dart';
import 'package:flutter_login/utils/apis/userInfo.dart';
import 'package:flutter_login/widgets/addApi.dart';
import 'package:flutter_login/widgets/iconTile.dart';
import 'package:flutter_login/widgets/propertyList.dart';
import 'package:flutter_login/widgets/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBody extends StatefulWidget {
    HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomSearchTextField(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 10),
          child: Text(
            "Top Features",
            style: GoogleFonts.righteous(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        CarouselSlider(
          items: images.map((imageAsset) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageAsset.imagePath,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            imageAsset.projectName,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
           onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                  _controller.animateToPage(
                    index,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.ease,
                  );
                });
              },
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.all(3),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                  Expanded(
                   child: GestureDetector(
                  onTap: ()=>{},
                    child: Card(
                      elevation: 3,
                      child: CustomIconTile(
                        iconData: Icons.security,
                        text: "100% Secure",
                      ),
                    ),
                  ),
                ),
                 
                Expanded(
                 child: GestureDetector(
                  onTap: ()=>{},
                  child: Card(
                    elevation: 3,
                    child: GestureDetector(
                      child: CustomIconTile(
                        iconData: Icons.monetization_on,
                        text: "Digital Estate",
                      ),
                    ),
                  ),
                ),),
                 
                Expanded(
                   child: GestureDetector(
                  onTap: ()=>{},
                  child: Card(
                    elevation: 3,
                    child: CustomIconTile(
                      iconData: Icons.location_on,
                      text: "Always on Support",
                    ),
                  ),
                ),),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 10),
          child: Text(
            "Available Shares",
            style: GoogleFonts.righteous(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        Expanded(
          child: PropertyCards(
            limit: 5,
          ),
        ), // Assuming PropertyCards manages its own scrolling if necessary
      ],
    );
  }
}

class ImageAsset {
  final String imagePath;
  final String projectName;

  ImageAsset({required this.imagePath, required this.projectName});
}
