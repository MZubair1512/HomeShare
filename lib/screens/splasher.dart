import "package:flutter/material.dart";
import "package:flutter_login/screens/login.dart";
import "package:flutter_login/screens/intro.dart";
import "package:google_fonts/google_fonts.dart";


class Splasher extends StatelessWidget {
  const Splasher({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 4),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Intro()));
    });

    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/meshGradient.jpg"),fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black54,BlendMode.darken))),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,   
          children: [
            Container(
              child: Image.asset("assets/logo-Black.png",fit: BoxFit.cover,width: 100,height: 100,),
              margin: const EdgeInsets.all(20),
            ),
            Text("HOME SHARE",style: GoogleFonts.righteous(
              fontSize: 30,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}