import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload/upload/my_textdfield2.dart';
import 'package:upload/upload/my_textfield.dart';
import 'package:upload/upload/my_textfild1.dart';

import '../firebase_service.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final nameController = TextEditingController();
  final ghanacardController = TextEditingController();
  final phonenumber = TextEditingController();
  final vinController = TextEditingController();
  final registrationnumberController = TextEditingController();
  final manufacturerNameController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final doorsController = TextEditingController();
  final bodyClassController = TextEditingController();
  final modelYearController = TextEditingController();
  final engineTypeController = TextEditingController();
  final plantCountryController = TextEditingController();
  final transmissionStyleController = TextEditingController();
  final numberofSeatRowsController = TextEditingController();
  final priceController = TextEditingController();

  List<File> _images = [];
  final FirebaseService _firebaseService = FirebaseService();

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

    if (nameController.text.isEmpty ||
        ghanacardController.text.isEmpty ||
        phonenumber.text.isEmpty ||
        vinController.text.isEmpty ||
        registrationnumberController.text.isEmpty ||
        manufacturerNameController.text.isEmpty ||
        vehicleTypeController.text.isEmpty ||
        makeController.text.isEmpty ||
        modelController.text.isEmpty ||
        doorsController.text.isEmpty ||
        bodyClassController.text.isEmpty ||
        modelYearController.text.isEmpty ||
        engineTypeController.text.isEmpty ||
        plantCountryController.text.isEmpty ||
        transmissionStyleController.text.isEmpty ||
        priceController.text.isEmpty ||
        numberofSeatRowsController.text.isEmpty
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
        name: nameController.text,
        ghanaCard: ghanacardController.text,
        phonenumber: phonenumber.text,
        vin: vinController.text,
        registrationnumber: registrationnumberController.text,
        imageUrls: imageUrls,
        manufacturerName: manufacturerNameController.text,
        vehicleType: vehicleTypeController.text,
        make: makeController.text,
        model: modelController.text,
        doors: doorsController.text,
        bodyClass: bodyClassController.text,
        modelYear: modelYearController.text,
        engineType: engineTypeController.text,
        plantCountry: plantCountryController.text,
        transmissionStyle: transmissionStyleController.text,
        numberOfSeatRows: numberofSeatRowsController.text,
        price: priceController.text,
        number: '', brand: '',
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
    nameController.clear();
    ghanacardController.clear();
    phonenumber.clear();
    vinController.clear();
    registrationnumberController.clear();
    manufacturerNameController.clear();
    vehicleTypeController.clear();
    makeController.clear();
    modelController.clear();
    doorsController.clear();
    bodyClassController.clear();
    modelYearController.clear();
    engineTypeController.clear();
    plantCountryController.clear();
    transmissionStyleController.clear();
    numberofSeatRowsController.clear();
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
          'Upload Forms',
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
                hintText: 'Full Name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField2(
                controller: phonenumber,
                hintText: 'Phone number',
                obscureText: false,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 10),

              MyTextField1(
                controller: ghanacardController,
                hintText: 'Ghana Card',
                obscureText: false,
                prefixIcon: Icons.add_card,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: vinController,
                hintText: 'Vehicle Identification Number (VIN)',
                obscureText: false,
                prefixIcon: Icons.verified_sharp,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: registrationnumberController,
                hintText: 'Registration Number',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: manufacturerNameController,
                hintText: 'Manufacturer Name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: vehicleTypeController,
                hintText: 'Vehicle Type',
                obscureText: false,
                prefixIcon: Icons.factory,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: makeController,
                hintText: 'Make',
                obscureText: false,
                prefixIcon: Icons.car_rental,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: modelController,
                hintText: 'Model',
                obscureText: false,
                prefixIcon: Icons.mode_edit_outline,
              ),
              const SizedBox(height: 10),

              MyTextField2(
                controller: doorsController,
                hintText: 'Doors',
                obscureText: false,
                prefixIcon: Icons.door_back_door,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: bodyClassController,
                hintText: 'Body Class',
                obscureText: false,
                prefixIcon: Icons.category,
              ),
              const SizedBox(height: 10),

              MyTextField2(
                controller: modelYearController,
                hintText: 'Model Year',
                obscureText: false,
                prefixIcon: Icons.calendar_today,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: engineTypeController,
                hintText: 'Engine Type',
                obscureText: false,
                prefixIcon: Icons.engineering,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: plantCountryController,
                hintText: 'Plant Country',
                obscureText: false,
                prefixIcon: Icons.public,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: transmissionStyleController,
                hintText: 'Transmission Style',
                obscureText: false,
                prefixIcon: Icons.settings,
              ),
              const SizedBox(height: 10),

              MyTextField2(
                controller: numberofSeatRowsController,
                hintText: 'Number of Seat Rows',
                obscureText: false,
                prefixIcon: Icons.event_seat,
              ),
              const SizedBox(height: 20),

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
