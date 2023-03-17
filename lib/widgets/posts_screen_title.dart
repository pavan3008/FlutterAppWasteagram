import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WasteagramTitle extends StatelessWidget {
  const WasteagramTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final totalItemCount = snapshot.data!.docs.fold<int>(
            0,
            (total, post) => total + (post['quantity'] as int? ?? 0),
          );
          return Text(
            'Wasteagram - $totalItemCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (snapshot.hasError) {
          return const Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return const Text(
            'Wasteagram - 0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
