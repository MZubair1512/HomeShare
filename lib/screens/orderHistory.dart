import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryPage extends StatefulWidget {
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
      ),
      body: userEmail == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Portfolio')
                  .where('email', isEqualTo: userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;

                    DateTime addedDate = (data['addedDate'] as Timestamp).toDate();
                    String formattedDate = DateFormat('MMMM d, yyyy at h:mm:ss a').format(addedDate);
                    String basePricePerShare = data['basePricePerShare'];
                    String baseSellingPrice = data['baseSellingPrice'];
                    bool completed = data['completed'];
                    String developmentPhase = data['developmentPhase'];
                    String projectName = data['projectName'];
                    dynamic profitRate= data['profitRate'];
                    String shareArea = data['shareArea'];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        trailing: profitRate>0? Icon(Icons.keyboard_double_arrow_up,color: Colors.green,): Icon(Icons.keyboard_double_arrow_down,color: Colors.red,),
                        title: Text(projectName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Added Date: $formattedDate',style: TextStyle(fontSize: 10)),
                            Text('Base Price Per Share: $basePricePerShare',style: TextStyle(fontSize: 10)),
                            Text('Base Selling Price: $baseSellingPrice',style: TextStyle(fontSize: 10)),
                            Text('Area Owned: ${shareArea}',style: TextStyle(fontSize: 10)),
                            Text('Development Phase: $developmentPhase',style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
