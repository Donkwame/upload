import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService1 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('store').child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> submitForm({
    required String name,
    required String brand,
    required String condition,
    required List<String> imageUrls,
    required String partnumber,
    required String price,
    

    
  }) async {
    try {
      CollectionReference vehicles = _firestore.collection('store');

      await vehicles.add({
        'brand': brand,
        'condition': condition,
        'name': name,
        'images': imageUrls,
        'partnumber': partnumber,
        'price': price,
        
        
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit form: $e');
    }
  }
}
