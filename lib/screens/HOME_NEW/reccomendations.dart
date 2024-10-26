import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendationCard extends StatefulWidget {
  const RecommendationCard({Key? key}) : super(key: key);

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  bool loading = true;
  List<Map<String, dynamic>> pos = [];

  void getData() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.1.210.255:5000/recc_crypto'));

    try {
      print("heeheheheheheh");
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        var result = jsonDecode(value);

        print("heheheheheheiqu19uej94444444");

        for (String entry in result['positive_senti']) {
          // Split the string by ' - ' to separate title and remark
          List<String> parts = entry.split('-');
          if (parts.length >= 2) {
            String title = parts[0].trim();
            String remark = parts[1].trim();

            pos.add({
              'title': title,
              'icon': Icons.trending_up,
              'remark': remark,
              'color': Colors.green.withOpacity(0.2),
              'gradientColors': [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.1),
              ],
            });
          }
        }

        setState(() {
          loading = false;
        });
      }).onError((error) {
        print("Error occurred: $error");
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.recommend,
                        color: Colors.blue,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Postive Sentiment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Recommendations List
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: pos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildGlassContainer(
                          pos[index]['title'],
                          pos[index]['icon'],
                          pos[index]['color'],
                          pos[index]['gradientColors'],
                          pos[index]['remark'],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
  }

  Widget _buildGlassContainer(
    String title,
    IconData icon,
    Color backgroundColor,
    List<Color> gradientColors,
    String remark,
  ) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              remark,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
