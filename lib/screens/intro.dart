import 'package:flutter/material.dart';
import 'package:flutter_login/screens/login.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: height * 0.05),
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                buildPage(
                  context,
                  width,
                  height,
                  "assets/images/house2.jpg",
                  "Discover the market of Real Estate from new Perspective",
                  "Own a Piece of New Developments and Influence Tomorrow’s Housing",
                ),
                buildPage(
                  context,
                  width,
                  height,
                  "assets/images/house1.jpg",
                  "Transform How You Invest in Real Estate",
                  "Own Shares in Development Projects and Be Part of a remarkable Journey throughout Whole Pakistan",
                ),
                buildPage(
                  context,
                  width,
                  height,
                  "assets/images/house3.jpg",
                  "Be Part of the Future of Housing",
                  "Diversify your portfolio with a fraction of the investment while enjoying curated property selections.n",
                ),
              ],
            ),
          ),
          Container(
            width: 260,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 237, 80),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(199, 65, 64, 64),
                ),
              ),
              onPressed: () {
                if (_controller.page == 2) {
                  // Navigate to the login page here
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
            ),
          ),
          SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: WormEffect(
              dotHeight: 9,
              dotWidth: 9,
              activeDotColor: Color.fromARGB(255, 255, 237, 80),
              dotColor: Colors.grey,
            ),
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, double width, double height, String imagePath, String title, String subtitle) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  imagePath,
                  height: height * 0.55,
                  width: width * 0.9,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            subtitle,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}