import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload/Store/firebase_service.dart';
import 'package:upload/Store/my_textfield3.dart';
import 'package:upload/upload/my_textdfield2.dart';
import 'package:upload/upload/my_textfield.dart';
//import 'package:upload/upload/my_textfild1.dart';



class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _UploadState();
}

class _UploadState extends State<Store> {
  final brandController = TextEditingController();
  final conditionController = TextEditingController();
  final nameController = TextEditingController();
  final partnumberController = TextEditingController();
  final priceController = TextEditingController();
  


  List<File> _images = [];
  final FirebaseService1 _firebaseService = FirebaseService1();

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadData() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    if (
        brandController.text.isEmpty ||
        conditionController.text.isEmpty ||
        nameController.text.isEmpty ||
        partnumberController.text.isEmpty ||
        priceController.text.isEmpty
        
        )
        {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      List<String> imageUrls = await _firebaseService.uploadImages(_images);
      await _firebaseService.submitForm(
        brand: brandController.text,
        condition: conditionController.text,
        name: nameController.text,
        imageUrls: imageUrls,
        partnumber: partnumberController.text,
        price: priceController.text,
        
  
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully')),
      );

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form: $e')),
      );
    }
  }

  void _clearForm() {
    brandController.clear();
    conditionController.clear();
    nameController.clear();
    partnumberController.clear();
    priceController.clear();
    
    setState(() {
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Forms',
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 36, 41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _images.isEmpty
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                              size: 50,
                            )
                          : Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _images
                                  .map(
                                    (image) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                      const SizedBox(height: 10),
                      Text(
                        _images.isEmpty
                            ? 'Tap to pick images'
                            : 'Tap to add more images',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Fields


              MyTextField(
                controller: nameController,
                hintText: 'Name of the Part',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: brandController,
                hintText: 'Brand Name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              

              MyTextField3(
                controller: conditionController,
                hintText: 'Condition',
                obscureText: false,
                prefixIcon: Icons.add_card,
              ),
              const SizedBox(height: 10),

          

            

              MyTextField(
                controller: partnumberController,
                hintText: 'Part Number',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),


              MyTextField2(
                controller: priceController,
                hintText: 'Price',
                obscureText: false,
                prefixIcon: Icons.price_change,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _uploadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Customize button color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.inter(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
