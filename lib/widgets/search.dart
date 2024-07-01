import 'package:flutter/material.dart';
import 'package:flutter_login/screens/search.dart';

class CustomSearchTextField extends StatelessWidget {
  final Function()? onSearchTap;
  final Function()? onFilterTap;

  CustomSearchTextField({this.onSearchTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 250, 210, 79)),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap ??
                  () {
                     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
                  },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 250, 210, 79),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Find Properties and market info',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          
        ],
      ),
    );
  }
}
