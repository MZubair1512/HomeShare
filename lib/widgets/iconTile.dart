import 'package:flutter/material.dart';

class CustomIconTile extends StatelessWidget {
  final IconData iconData;
  final String text;

  const CustomIconTile({
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(158, 255, 237, 77), 
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 12,
            color: Color.fromARGB(255, 0, 0, 0), 
          ),
          SizedBox(height: 1),
          Text(
            text,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), 
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
