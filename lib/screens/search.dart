import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/screens/description.dart';
import 'package:flutter_login/widgets/propertyList.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allProperties = []; // Stores all properties
  List<Map<String, dynamic>> filteredProperties = []; // Filtered based on search

  @override
  void initState() {
    super.initState();
    // Fetch all properties on initial state
    fetchAllProperties();
  }

  void fetchAllProperties() async {
    try {
      CollectionReference propertiesRef = FirebaseFirestore.instance.collection('properties');
      QuerySnapshot querySnapshot = await propertiesRef.get();

      setState(() {
        allProperties = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  void searchProperties(String query) {
    filteredProperties = allProperties.where((property) {
      String projectName = property['projectName']?.toLowerCase() ?? '';
      return projectName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      // Update filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Properties'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter Property/Projectname',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  String query = _searchController.text.trim();
                  searchProperties(query);
                },
              ),
            ),
            onSubmitted: (value) {
              String query = _searchController.text.trim();
              searchProperties(query);
            },
          ),
          Expanded(
          child: filteredProperties.isEmpty
              ? Center(child: Text('No properties found'))
              :  ListView.builder(
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: GestureDetector(onTap: (){
                    String name =filteredProperties[index]['projectName'];
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>PropertyDetailPage(PropertyN: name,)));
                    },child: Text(filteredProperties[index]['projectName'])),
                  // Customize how you want to display each property
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
