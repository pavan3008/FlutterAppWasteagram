import 'package:flutter/material.dart';
import 'package:wasteagram/screens/posts_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Posts(),
    );
  }
}
