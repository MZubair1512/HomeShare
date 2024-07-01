import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/screens/blogDescription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsAndBlogsPage extends StatefulWidget {
  @override
  _NewsAndBlogsPageState createState() => _NewsAndBlogsPageState();
}

class _NewsAndBlogsPageState extends State<NewsAndBlogsPage> {
  List<NewsInfo> newsList = [];
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('NewsAndBlogs');
    QuerySnapshot querySnapshot = await collectionRef.orderBy('writtenDate', descending: true).get();
    final List<NewsInfo> fetchedNews = querySnapshot.docs.map((doc) {
      return NewsInfo(
        author: doc['author'],
        description: doc['description'],
        image: doc['image'],
        title: doc['title'],
        writtenDate: doc['writtenDate'],
      );
    }).toList();

    setState(() {
      newsList = fetchedNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    String id = "LG2VrSLY34k";
    _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),);
    return  ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return NewsCard(news: newsList[index]);
            },
          );

  }
}

class NewsInfo {
  final String author;
  final String description;
  final String image;
  final String title;
  final String writtenDate;

  NewsInfo({
    required this.author,
    required this.description,
    required this.image,
    required this.title,
    required this.writtenDate,
  });
}

class NewsCard extends StatelessWidget {
  final NewsInfo news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>BlogDetailPage(blogInfo: news)));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Lighter cool blue for better text readability
                  Color.fromARGB(205, 240, 239, 238),
                  Color.fromARGB(205, 240, 239, 238), // Darker cool blue
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(
                    news.image,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 233, 128, 16), // Darker text for better contrast
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        news.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0, // Slightly smaller description text
                          color: Colors.grey[600], // Darker gray for readability
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            news.author,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600], // Lighter gray for subtle information
                            ),
                          ),
                          Text(
                            news.writtenDate,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600], // Lighter gray for subtle information
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
        ),
      ),
    );
  }
}
