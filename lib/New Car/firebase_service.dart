import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('newcar').child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> submitForm({
    required String exportername,
    required String inportername,
    required String inporternumber,
    required String vin ,
    required List<String> imageUrls,
    //required String representativename,
    //required String representativenumber,
    required String manufacturerName,
    required String countryoforigin,
    required String make,
    required String model,
    required String mtrans,
    required String dvplatenumber,
    required String modelYear,
    required String engineType,
    required String  plantCountry,
    required String  transmissionStyle,
    required String  numberofSeatRows,
    required String duty,
    required String  date,
    required String deliveryplace,
    

    
  }) async {
    try {
      CollectionReference vehicles = _firestore.collection('GRA');

      await vehicles.add({
        'exportername': exportername,
        'inportername': inportername,
        'inporternumber': inporternumber,
        'plantCountry ':  plantCountry ,
        'vin':  vin,
        'images': imageUrls,
        //'representativename': representativename,
        //'representativenumber':  representativenumber,
        'manufacturerName': manufacturerName,
        'countryoforigin': countryoforigin,
        'make': make,
        'engineType': engineType,
        'mtransr':  mtrans,
        'dvplatenumber': dvplatenumber,
        'modelYear': modelYear,
        'transmissionStyle': transmissionStyle,
       // 'transmissionStyle':  transmissionStyle,
        'numberofSeatRows;':  numberofSeatRows,
        'duty':  duty,
        'date':  date,
        'deliveryplace':  deliveryplace,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit form: $e');
    }
  }
}
