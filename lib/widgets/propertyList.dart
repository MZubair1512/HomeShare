import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/screens/description.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyCards extends StatefulWidget {
  final int? limit;

  PropertyCards({super.key, this.limit});

  @override
  State<PropertyCards> createState() => _PropertyCardsState();
}

class _PropertyCardsState extends State<PropertyCards> {
  List<PropertyInfo> properties = [];

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('properties');
    QuerySnapshot querySnapshot;
    if (widget.limit == null) {
      querySnapshot = await collectionRef.get();
    } else {
      querySnapshot = await collectionRef.limit(widget.limit!).get();
    }
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
      properties = fetchedProperties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return PropertyCard(property: properties[index]);
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

class PropertyCard extends StatefulWidget {
  final PropertyInfo property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isFavorite = false;
  late SharedPreferences prefs;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    initPrefs();
    checkIfFavorite();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email');
  }

  Future<void> checkIfFavorite() async {
    if (userEmail != null) {
      final userFavorites = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('favorites')
          .doc(widget.property.projectName)
          .get();

      if (userFavorites.exists) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  Future<void> toggleFavorite() async {
    if (userEmail == null) return;

    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('favorites');

    if (isFavorite) {
      await favoritesCollection.doc(widget.property.projectName).delete();
    } else {
      await favoritesCollection.doc(widget.property.projectName).set({
        'image': widget.property.image,
        'builderName': widget.property.builderName,
        'projectName': widget.property.projectName,
        'developmentPhase': widget.property.developmentPhase,
        'basePricePerShare': widget.property.basePricePerShare,
        'shareArea': widget.property.shareArea,
        'address': widget.property.address,
        'completed': widget.property.completed,
        'profitRate': widget.property.profitRate,
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      PropertyDetailPage(PropertyN: widget.property.projectName)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.property.image),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.0)),
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
                        widget.property.projectName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: toggleFavorite,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.property.address,
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
                              widget.property.developmentPhase,
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
                              'Base Price: ${widget.property.basePricePerShare}',
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
                              'Share Area: ${widget.property.shareArea}',
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
  }
}
