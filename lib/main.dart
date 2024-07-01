import 'package:flutter/material.dart';
import 'package:flutter_login/screens/splasher.dart';
import 'package:flutter_login/screens/intro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey="pk_test_51POLSORr2k4AYrtAOOYjO2SMtsENDlIASpZwrlpt5IpH8NLcO4BVpHBhzLlva2AUDQdP3Mp5z7Uc69yvHALJPlOz00HsM3RWZX";
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const App());
  });
  
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const Splasher(),
     );
      }
}


