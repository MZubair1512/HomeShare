import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/widgets/propertyList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertyDetailPage extends StatefulWidget {
  final dynamic PropertyN;

  PropertyDetailPage({Key? key, required this.PropertyN}) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  Map<String, dynamic>? propertyDetails;
  String? PropertyName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails(widget.PropertyN);
  }

  Future<void> fetchPropertyDetails(String projectName) async {
    try {
      // Fetch data from properties collection
      QuerySnapshot propertiesSnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .where('projectName', isEqualTo: projectName)
          .get();

      if (propertiesSnapshot.docs.isNotEmpty) {
        var property = propertiesSnapshot.docs.first.data();
        setState(() {
          propertyDetails = property as Map<String, dynamic>?;
        });

        // Fetch data from PropertyDescription collection
        QuerySnapshot descriptionSnapshot = await FirebaseFirestore.instance
            .collection('propertiesDescription')
            .where('projectName', isEqualTo: projectName)
            .get();

        if (descriptionSnapshot.docs.isNotEmpty) {
          var description = descriptionSnapshot.docs.first.data();
          setState(() {
            if (propertyDetails != null) {
              Map<String, dynamic> data = description as Map<String, dynamic>;
              propertyDetails!.addAll(data);
              isLoading = false;
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching property details: $e');
    }
  }

  displayPaymentSheet(email, property) async {
    try {
      // Display payment sheet
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      // Displaying snackbar for it
      await FirebaseFirestore.instance.collection('Portfolio').add({
        'email': email,
        'projectName': property['projectName'],
        'completed': property['completed'],
        'basePricePerShare': property['basePricePerShare'],
        'baseSellingPrice': property['baseSellingPrice'],
        'developmentPhase': property['developmentPhase'],
        'profitRate': property['profitRate'],
        'shareArea': property['shareArea'],
        'addedDate': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );
    } on StripeException catch (e) {
      // If any error comes during payment
      // so payment will be cancelled
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  Future<void> _payViaNewCard(BuildContext context, int amount, email, property) async {
    try {
      dynamic response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51POLSORr2k4AYrtAMTYxJpf3cZ55y7E23oRnHNAVtT96O28obBtB6zPA9ts8O7fdum9qIlw733YqhLuUbG6tNh7B008htkEosZ',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount.toString(),
          'currency': 'pkr',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final paymentIntent = json.decode(response.body);

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Client secret key from payment data
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            googlePay: const PaymentSheetGooglePay(
              testEnv: true,
              currencyCode: "us",
              merchantCountryCode: "us",
            ),
            // Merchant Name
            merchantDisplayName: 'Home Share',
            // return URL if you want to add
            // returnURL: 'flutterstripe://redirect',
          ),
        );
        displayPaymentSheet(email, property);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create payment intent')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Description",
          style: GoogleFonts.righteous(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top:20.0,right:20.0,left:20,bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          propertyDetails?['image'],
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      propertyDetails?['projectName'],
                      style: GoogleFonts.righteous(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Builders: ${propertyDetails?['builderName']}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      propertyDetails?['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      tileColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Icon(Icons.attach_money, color: Colors.white),
                      title: Text(
                        'Base Share Price: ${propertyDetails?['basePricePerShare']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Icon(Icons.home, color: Colors.white),
                      title: Text(
                        'Share Area: ${propertyDetails?['shareArea']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Icon(Icons.category, color: Colors.white),
                      title: Text(
                        'Development Phase: ${propertyDetails?['developmentPhase']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Icon(Icons.trending_up, color: Colors.white),
                      title: Text(
                        'Profit Rate: ${propertyDetails?['profitRate']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          String numericString = propertyDetails?['basePricePerShare'].replaceAll(RegExp(r'[^\d]'), '');
          int amountperShare = int.parse(numericString);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var email = prefs.getString('email');

          _payViaNewCard(context, (amountperShare * 0.0036 * 100).toInt(), email, propertyDetails);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, size: 24, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Add to Portfolio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
