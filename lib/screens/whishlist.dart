import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login/screens/description.dart';

class WishlistedPropertiesPage extends StatefulWidget {
  @override
  _WishlistedPropertiesPageState createState() => _WishlistedPropertiesPageState();
}

class _WishlistedPropertiesPageState extends State<WishlistedPropertiesPage> {
  List<PropertyInfo> wishlistedProperties = [];
  late SharedPreferences prefs;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email');
    fetchWishlistedProperties();
  }

  Future<void> fetchWishlistedProperties() async {
    if (userEmail == null) return;

    final CollectionReference favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('favorites');

    QuerySnapshot querySnapshot = await favoritesCollection.get();
    final List<PropertyInfo> fetchedProperties = querySnapshot.docs.map((doc) {
      return PropertyInfo(
        image: doc['image'],
        builderName: doc['builderName'],
        projectName: doc['projectName'],
        developmentPhase: doc['developmentPhase'],
        basePricePerShare: doc['basePricePerShare'],
        shareArea: doc['shareArea'],
        address: doc['address'],
        completed: doc['completed'],
        profitRate: doc['profitRate'],
      );
    }).toList();

    setState(() {
      wishlistedProperties = fetchedProperties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlisted Properties'),
      ),
      body: wishlistedProperties.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: wishlistedProperties.length,
              itemBuilder: (context, index) {
                final property = wishlistedProperties[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PropertyDetailPage(PropertyN: property.projectName),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(property.image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    property.builderName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Wishlist functionality not needed here
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                property.address,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.developer_board,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          property.developmentPhase,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Base Price: ${property.basePricePerShare}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.aspect_ratio,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Share Area: ${property.shareArea}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PropertyInfo {
  final String image;
  final String builderName;
  final String projectName;
  final String developmentPhase;
  final String basePricePerShare;
  final String shareArea;
  final String address;
  final bool completed;
  final dynamic profitRate;

  PropertyInfo({
    required this.image,
    required this.builderName,
    required this.projectName,
    required this.developmentPhase,
    required this.basePricePerShare,
    required this.shareArea,
    required this.address,
    required this.completed,
    required this.profitRate,
  });

  String getAddress() => address;
  String getBasePricePerShare() => basePricePerShare;
  String getBuilderName() => builderName;
  bool isCompleted() => completed;
  String getDevelopmentPhase() => developmentPhase;
  String getImage() => image;
  double getProfitRate() => profitRate;
  String getProjectName() => projectName;
  String getShareArea() => shareArea;
}
