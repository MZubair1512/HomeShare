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

class PropertySearch extends StatefulWidget {
  const PropertySearch({super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch> {
  late PageController _controller;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 @override
  Widget build(BuildContext context) {
    return  PropertyCards();
  }
}
