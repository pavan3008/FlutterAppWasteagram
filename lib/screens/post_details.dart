import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/food_post.dart';

class PostDetailScreen extends StatelessWidget {
  final FoodPost post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateToString = DateFormat('EE, MMMM d, y').format(post.date);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FoodWaste',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dateToString,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 300,
              child: Image.network(
                post.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '${post.quantity} items wasted',
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Location: ${post.latitude}, ${post.longitude}',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}