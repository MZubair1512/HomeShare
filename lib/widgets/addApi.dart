import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addProperties(context) {
  WriteBatch batch = FirebaseFirestore.instance.batch();

  List<Map<String, dynamic>> propertiesList = [
  {
    "title": "Welcome to HomeShare",
    "subtitle": "We're glad to have you on board. Explore and find your perfect home.",
    "date": "2024-07-01",
    "image": "assets/images/welcome.jpg"
  },
  {
    "title": "User Guide",
    "subtitle": "Take a look at our comprehensive guide to get started with HomeShare.",
    "date": "2024-07-01",
    "image": "assets/images/user_guide.jpg"
  },
  {
    "title": "Update Available",
    "subtitle": "Our app just got better! Update now to enjoy the latest features.",
    "date": "2024-07-01",
    "image": "assets/images/update.jpg"
  },
  {
    "title": "New Policies",
    "subtitle": "Please review our updated policies to stay informed.",
    "date": "2024-07-01",
    "image": "assets/images/policies.jpg"
  },
  {
    "title": "Exclusive Offers",
    "subtitle": "Check out our latest exclusive offers available only for you.",
    "date": "2024-07-01",
    "image": "assets/images/offers.jpg"
  },
  {
    "title": "Referral Program",
    "subtitle": "Invite your friends and earn rewards with our new referral program.",
    "date": "2024-07-01",
    "image": "assets/images/referral.jpg"
  },
  {
    "title": "Help & Support",
    "subtitle": "Need assistance? Our support team is here to help you 24/7.",
    "date": "2024-07-01",
    "image": "assets/images/support.jpg"
  },
  {
    "title": "Feedback",
    "subtitle": "We value your feedback. Share your thoughts and help us improve.",
    "date": "2024-07-01",
    "image": "assets/images/feedback.jpg"
  },
];
  propertiesList.forEach((property) {
    DocumentReference docRef = FirebaseFirestore.instance.collection('Notification').doc();
batch.set(docRef, {
      'title': property['title'],
      'subtitle': property['subtitle'],
      'date': property['date'],
      'image': property['image'],
    });
  });


  // Commit the batch
  batch.commit().then((_) {
    print("done");
  }).catchError((error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  });
}