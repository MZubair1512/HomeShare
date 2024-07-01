import 'package:flutter/material.dart';
import 'package:flutter_login/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_credit_card/u_credit_card.dart'; // Replace with your actual widget imports

class Portfolio extends StatefulWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  late PageController _controller;
  int _currentIndex = 0;
  String? userEmail;
  dynamic userData;
  List<dynamic> projects = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
    loadUserEmail();
  }

  Future<void> loadUserEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userEmail = pref.getString("email");
    });
    fetchUserDetailsAndUpdateState();
  }

  Future<void> fetchUserDetailsAndUpdateState() async {
    if (userEmail != null) {
      try {
        // Fetch user details
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userEmail)
            .get();
        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data();
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    if (userEmail != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Portfolio')
            .where('email', isEqualTo: userEmail)
            .get();
        setState(() {
          projects = snapshot.docs.map((doc) => doc.data()).toList();
          isLoading = false; // Update loading state
        });
      } catch (e) {
        print('Error fetching projects: $e');
        setState(() {
          projects = [];
          isLoading = false; // Update loading state
        });
      }
    }
  }

  double calculateTotalProfit(List<dynamic> projects) {
    double totalProfit = 0.0;
    projects.forEach((project) {
      double profitRate = project['profitRate'];
      String cleanedValue = project['baseSellingPrice'].replaceAll('Rs', '').replaceAll(',', '');
      double baseSellingPrice = double.parse(cleanedValue.substring(1));
      totalProfit += profitRate * baseSellingPrice;
    });
    return totalProfit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
        leading: GestureDetector(onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()))},child: Icon(Icons.keyboard_arrow_down_outlined)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: userData != null
                        ? CreditCardUi(
                            cardHolderFullName: "${userData["fullName"]}",
                            cardNumber: "${userData["bankAccountDetails"]}",
                            validThru: "XXXX",
                            topLeftColor: Colors.yellow.shade600,
                            bottomRightColor: Colors.orange.shade700,
                            cardProviderLogo: Image.asset("assets/icon.png"),
                          )
                        : SizedBox.shrink(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Ongoing Projects (Upward)",
                    style: GoogleFonts.righteous(
                      fontSize: 23,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  buildProjectsList(upward: true),
                  SizedBox(height: 16.0),
                  Text(
                    "Ongoing Projects (Downward)",
                    style: GoogleFonts.righteous(
                      fontSize: 23,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  buildProjectsList(upward: false),
                  SizedBox(height: 16.0),
                  Text(
                    "Completed Projects",
                    style: GoogleFonts.righteous(
                      fontSize: 23,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  buildCompletedProjectsList(),
                  ListTile(
                    leading: Icon(Icons.money),
                    title: Text("Revenue Projection"),
                    subtitle:
                        Text("Total Revenue Projected: RS ${calculateTotalProfit(projects)}"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildProjectsList({required bool upward}) {
    List<dynamic> filteredProjects = projects.where((project) {
      if (upward) {
        return project['profitRate'] > 0 && !project['completed'];
      } else {
        return project['profitRate'] < 0 && !project['completed'];
      }
    }).toList();

    if (filteredProjects.isEmpty) {
      return Center(child: Text('No projects found.'));
    }

    return Column(
      children: filteredProjects.map((project) {
        return ExpansionTile(
          title: Text(project['projectName']),
          children: [
            ListTile(
              title: Text('Expected Rate (Next Round): ${project['profitRate']}', style: TextStyle(fontSize: 12)),
              trailing: Icon(upward ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down,
                  color: upward ? Colors.green : Colors.red),
            ),
            buildSellButton(),
          ],
        );
      }).toList(),
    );
  }

  Widget buildCompletedProjectsList() {
    List<dynamic> completedProjects = projects.where((project) => project['completed']).toList();
    if (completedProjects.isEmpty) {
      return Center(child: Text('No completed projects found.'));
    }

    return Column(
      children: completedProjects.map((project) {
        return ExpansionTile(
          title: Text(project['projectName']),
          children: [
            ListTile(
              title: Text('Current Profit Rate: ${project['profitRate']}', style: TextStyle(fontSize: 12)),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            buildSellButton(),
          ],
        );
      }).toList(),
    );
  }

  Widget buildSellButton() {
    return IconButton(
      icon: Icon(Icons.sell),
      tooltip: "Sell the Share",
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Sell Share"),
              content: Text("Are you sure you want to sell this project?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Sell"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sell Project"),
                          content: Text("Our team is reviewing your request. We will contact you shortly."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the 'Our team will contact you' dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
