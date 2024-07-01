import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class PropertyCards extends StatefulWidget {
  var limit;

  PropertyCards({super.key,this.limit});


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
    if(widget.limit==null){
      QuerySnapshot querySnapshot = await collectionRef.get();
      final List<PropertyInfo> fetchedProperties = querySnapshot.docs.map((doc) {
      return PropertyInfo(
        image: doc['image'],
        builderName: doc['builderName'],
        projectName: doc['projectName'],
        developmentPhase: doc['developmentPhase'],
        basePricePerShare: doc['basePricePerShare'],
        shareArea: doc['shareArea'],
        address: doc['address'],
      );
    }).toList();

    setState(() {
      properties = fetchedProperties;
    });

    }else{
      QuerySnapshot querySnapshot = await collectionRef.limit(widget.limit).get();
      final List<PropertyInfo> fetchedProperties = querySnapshot.docs.map((doc) {
      return PropertyInfo(
        image: doc['image'],
        builderName: doc['builderName'],
        projectName: doc['projectName'],
        developmentPhase: doc['developmentPhase'],
        basePricePerShare: doc['basePricePerShare'],
        shareArea: doc['shareArea'],
        address: doc['address'],
      );
    }).toList();

    setState(() {
      properties = fetchedProperties;
    });
    }
    
    
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

  PropertyInfo({
    required this.image,
    required this.builderName,
    required this.projectName,
    required this.developmentPhase,
    required this.basePricePerShare,
    required this.shareArea,
    required this.address,
  });
}

class PropertyCard extends StatelessWidget {
  final PropertyInfo property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'HouseDetails');
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
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
                          Icons.favorite_border,
                        ),
                        onPressed: () {
                          // Handle wishlist functionality
                          // Add your logic to store in user's wishlist
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
  }
}
