import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBusImage extends StatefulWidget {
  @override
  _AddBusImageState createState() => _AddBusImageState();
}

class _AddBusImageState extends State<AddBusImage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('images').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => Image.network(data[index]['url']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50, // Reduce image size for faster upload
          );

          if (image != null) {
            String url = await uploadImage(image);
            addImageToFirestore(url);
          }
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<String> uploadImage(XFile image) async {
    final reference = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final task = reference.putFile(File(image.path));
    final snapshot = await task.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> addImageToFirestore(String url) async {
    final docRef = _firestore.collection('images').doc();
    await docRef.set({
      'url': url,
      'timestamp': DateTime.now(), // Optional: Add a timestamp
    });
  }
}
