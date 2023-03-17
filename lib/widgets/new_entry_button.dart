import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

import '../screens/new_post.dart';

class NewEntryButton extends StatelessWidget {
  const NewEntryButton({Key? key}) : super(key: key);

  Future<String?> _uploadImageToFirebaseStorage(File pickedImage) async {
    try {
      final firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance
              .ref()
              .child(path.basename(pickedImage.path));
      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(pickedImage);
      await uploadTask;
      final String imageURL = await storageReference.getDownloadURL();
      return imageURL;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    final String? imageURL = await _uploadImageToFirebaseStorage(
        File(pickedImage.path)); // Upload image to Firebase storage
    if (imageURL != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewPostScreen(
                imageURL: imageURL,
              )));
    } else {
      debugPrint('Error uploading image to Firebase storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Brings up camera roll to select and image',
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add),
        onPressed: () async {
          await _showImagePicker(context);
        },
      ),
    );
  }
}
