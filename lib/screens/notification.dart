import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationInfo> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('Notification');
    QuerySnapshot querySnapshot = await collectionRef.get();
    final List<NotificationInfo> fetchedNotifications = querySnapshot.docs.map((doc) {
      return NotificationInfo(
        date: doc['date'],
        image: doc['image'],
        subtitle: doc['subtitle'],
        title: doc['title'],
      );
    }).toList();

    setState(() {
      notifications = fetchedNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              NotificationCard(notification: notifications[index]),
              Divider(height: 1, thickness: 1),
            ],
          );
        },
      ),
    );
  }
}

class NotificationInfo {
  final String date;
  final String image;
  final String subtitle;
  final String title;

  NotificationInfo({
    required this.date,
    required this.image,
    required this.subtitle,
    required this.title,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationInfo notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/icon.png"),
          radius: 30.0,
        ),
        title: Text(notification.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(notification.subtitle, style: TextStyle(fontSize: 12)),
        trailing: Text(notification.date, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ),
    );
  }
}
