import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AgentsListPage extends StatefulWidget {
  @override
  _AgentsListPageState createState() => _AgentsListPageState();
}

class _AgentsListPageState extends State<AgentsListPage> {
  List<AgentInfo> agents = [];

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('Agents');
    QuerySnapshot querySnapshot = await collectionRef.get();
    final List<AgentInfo> fetchedAgents = querySnapshot.docs.map((doc) {
      return AgentInfo(
        city: doc['city'],
        company: doc['company'],
        email: doc['email'],
        fullName: doc['fullName'],
        licenseNumber: doc['licenseNumber'],
        phone: doc['phone'],
        state: doc['state'],
      );
    }).toList();

    setState(() {
      agents = fetchedAgents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agents'),
      ),
      body: ListView.builder(
        itemCount: agents.length,
        itemBuilder: (context, index) {
          return AgentCard(agent: agents[index]);
        },
      ),
    );
  }
}

class AgentInfo {
  final String city;
  final String company;
  final String email;
  final String fullName;
  final String licenseNumber;
  final String phone;
  final String state;

  AgentInfo({
    required this.city,
    required this.company,
    required this.email,
    required this.fullName,
    required this.licenseNumber,
    required this.phone,
    required this.state,
  });

  String getInitials() {
    return fullName.split(' ').map((e) => e[0]).take(2).join();
  }
}

class AgentCard extends StatelessWidget {
  final AgentInfo agent;

  const AgentCard({Key? key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(211, 60, 226, 118),
          radius: 30.0,
          child: Text(
            agent.getInitials(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(agent.fullName,style: GoogleFonts.righteous()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${agent.company}', style: TextStyle(fontSize: 10)),
            Text('City: ${agent.city}', style: TextStyle(fontSize: 10)),
            Text('State: ${agent.state}', style: TextStyle(fontSize: 10)),
            Text('License: ${agent.licenseNumber}', style: TextStyle(fontSize: 10)),
            Text('Email: ${agent.email}', style: TextStyle(fontSize: 10)),
          ],
        ),
        trailing: Icon(Icons.copy),
        onTap: () {
          Clipboard.setData(ClipboardData(text: agent.phone));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone number copied to clipboard')),
          );
        },
      ),
    );
  }
}
