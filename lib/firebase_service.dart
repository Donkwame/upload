import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('uploads').child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> submitForm({
    required String name,
    required String ghanaCard,
    required String phonenumber,
    required String vin,
    required List<String> imageUrls,
    required String manufacturerName,
    required String vehicleType,
    required String registrationnumber,
    required String make,
    required String model,
    required String doors,
    required String bodyClass,
    required String modelYear,
    required String engineType,
    required String plantCountry,
    required String transmissionStyle,
    required String numberOfSeatRows,
    required String number,
    required String price, required String brand,
    

    
  }) async {
    try {
      CollectionReference vehicles = _firestore.collection('vehicles');

      await vehicles.add({
        'name': name,
        'ghanaCard': ghanaCard,
        'phonenumber': phonenumber,
        'vin': vin,
        'registrationnumber': registrationnumber,
        'images': imageUrls,
        'manufacturerName': manufacturerName,
        'vehicleType': vehicleType,
        'make': make,
        'model': model,
        'doors': doors,
        'bodyClass': bodyClass,
        'modelYear': modelYear,
        'engineType': engineType,
        'plantCountry': plantCountry,
        'transmissionStyle': transmissionStyle,
        'numberOfSeatRows': numberOfSeatRows,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit form: $e');
    }
  }
}
