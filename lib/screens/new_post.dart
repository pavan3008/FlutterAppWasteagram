// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/screens/posts_list.dart';

class NewPostScreen extends StatefulWidget {
  final String imageURL;
  const NewPostScreen({Key? key, required this.imageURL}) : super(key: key);
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfWastedItems = 0;
  Map<String, dynamic> newPost = {};
  LocationData? locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    try {
      var serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var permissionGranted = await locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('New Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Image of wasted food item',
                    child: Image.network(
                      widget.imageURL,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Input',
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 24,
                      height: 2,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Number of Wasted Items',
                      contentPadding:
                          EdgeInsets.only(bottom: 20, top: 12),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    onSaved: (value) {
                      _numberOfWastedItems = int.parse(value!);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the number of wasted items';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      newPost['date'] = DateTime.now();
                      newPost['imageURL'] = widget.imageURL;
                      newPost['quantity'] = _numberOfWastedItems;
                      FirebaseFirestore.instance
                          .collection('posts')
                          .add(newPost)
                          .then(
                            (_) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const Posts()),
                              (route) => false,
                            ),
                          )
                          .catchError(
                            (error) => print('Failed to add post: $error'),
                          );
                    }
                  },
                  icon: const Icon(Icons.cloud_upload, size: 50),
                  label: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    minimumSize: const Size(double.infinity, 80),
                    elevation: 0,
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
