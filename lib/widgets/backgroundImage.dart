import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pxfuel.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Color.fromARGB(221, 24, 24, 24),BlendMode.darken)
      ),),);
  }
}