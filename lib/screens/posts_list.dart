import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/post_details.dart';
import 'package:wasteagram/widgets/posts_screen_title.dart';
import '../models/food_post.dart';
import '../widgets/new_entry_button.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WasteagramTitle(),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];
                var date = post['date'].toDate();
                var dateToString = DateFormat('EEEE, MMMM d, y').format(date);
                return Semantics(
                  label: 'Food waste posted on $dateToString with ${post['quantity']} wasted items',
                  enabled: true,
                  child: GestureDetector(
                    onTap: () {
                      FoodPost foodWastePost = FoodPost(
                        date: date,
                        imageURL: post['imageURL'],
                        quantity: post['quantity'],
                        latitude: post['latitude'],
                        longitude: post['longitude'],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(post: foodWastePost),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Text(
                        dateToString,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        post['quantity'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Welcome to Wasteagram!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Click button to add a post!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
      floatingActionButton: Semantics(
        button: true,
        enabled: true,
        onTapHint: 'Select an image',
        child: const NewEntryButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
