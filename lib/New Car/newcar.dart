import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload/New%20Car/firebase_service.dart'; // Adjust import if necessary
import 'package:upload/New%20Car/my_textfield.dart';
import 'package:upload/New%20Car/my_textfield4.dart';
import 'package:upload/upload/my_textfield.dart';

class NewCar extends StatefulWidget {
  const NewCar({super.key});

  @override
  State<NewCar> createState() => _UploadState();
}

class _UploadState extends State<NewCar> {
  final exporternameController = TextEditingController();
  final inporternameController = TextEditingController();
  final inporternumberController = TextEditingController();
  final vinController = TextEditingController();
  final representativenameController = TextEditingController();
  final representativenumberController = TextEditingController();
  final manufacturerNameController = TextEditingController();
  final countryoforiginController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final mtransController = TextEditingController();
  final dvplatenumberController = TextEditingController();
  final modelYearController = TextEditingController();
  final engineTypeController = TextEditingController();
  final plantCountryController = TextEditingController();
  final transmissionStyleController = TextEditingController();
  final numberofSeatRowsController = TextEditingController();
  final dutyController = TextEditingController();
  final dateController = TextEditingController();
  final deliveryplaceController = TextEditingController();

  List<File> _images = [];
  final FirebaseService2 _firebaseService = FirebaseService2();

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

    if (exporternameController.text.isEmpty ||
        inporternameController.text.isEmpty ||
        inporternumberController.text.isEmpty ||
        vinController.text.isEmpty ||
        //representativenameController.text.isEmpty ||
        manufacturerNameController.text.isEmpty ||
        //representativenumberController.text.isEmpty ||
        makeController.text.isEmpty ||
        modelController.text.isEmpty ||
        countryoforiginController.text.isEmpty ||
        mtransController.text.isEmpty ||
        modelYearController.text.isEmpty ||
        engineTypeController.text.isEmpty ||
        plantCountryController.text.isEmpty ||
        transmissionStyleController.text.isEmpty ||
        dutyController.text.isEmpty ||
        dateController.text.isEmpty ||
        deliveryplaceController.text.isEmpty ||
        dvplatenumberController.text.isEmpty ||
        numberofSeatRowsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      List<String> imageUrls = await _firebaseService.uploadImages(_images);
      await _firebaseService.submitForm(
        exportername: exporternameController.text,
        inportername: inporternameController.text,
        inporternumber: inporternumberController.text,
       // representativename: representativenameController.text,
        //representativenumber: representativenumberController.text ,
        vin: vinController.text,
         dvplatenumber: dvplatenumberController.text, // Assuming this is the registration number
        imageUrls: imageUrls,
        manufacturerName: manufacturerNameController.text,
       countryoforigin: countryoforiginController.text,
        make: makeController.text,
        model: modelController.text,
        mtrans: mtransController.text,
        modelYear: modelYearController.text,
        engineType: engineTypeController.text,
        plantCountry: plantCountryController.text,
        transmissionStyle: transmissionStyleController.text,
        numberofSeatRows: numberofSeatRowsController.text,
        duty: dutyController.text,
        date: dateController.text,
        deliveryplace: deliveryplaceController.text,
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
    exporternameController.clear();
    inporternameController.clear();
    inporternumberController.clear();
    vinController.clear();
    dvplatenumberController.clear();
    manufacturerNameController.clear();
    countryoforiginController.clear();
    makeController.clear();
    modelController.clear();
    mtransController.clear();
    engineTypeController.clear();
    plantCountryController.clear();
    transmissionStyleController.clear();
    numberofSeatRowsController.clear();
    dutyController.clear();
    dateController.clear();
    deliveryplaceController.clear();
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
                controller: exporternameController,
                hintText: 'Exporter Name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: inporternameController,
                hintText: 'Importer Name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: inporternumberController,
                hintText: 'Importer Number',
                obscureText: false,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 10),

              MyTextField4(
                controller: vinController,
                hintText: 'Vehicle Identification Number (VIN)',
                obscureText: false,
                prefixIcon: Icons.verified_sharp,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: dvplatenumberController,
                hintText: 'dv Number',
                obscureText: false,
                prefixIcon: Icons.verified,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: manufacturerNameController,
                hintText: 'Manufacturer Name',
                obscureText: false,
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: countryoforiginController,
                hintText: 'Country of Origin',
                obscureText: false,
                prefixIcon: Icons.public,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: makeController,
                hintText: 'Make',
                obscureText: false,
                prefixIcon: Icons.car_repair,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: modelController,
                hintText: 'Model',
                obscureText: false,
                prefixIcon: Icons.model_training,
              ),
              const SizedBox(height: 10),

              MyTextField5(
                controller: mtransController,
                hintText: 'mtrans',
                obscureText: false,
                prefixIcon: Icons.settings,
              ),
              const SizedBox(height: 10),

              MyTextField(
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

              MyTextField(
                controller: numberofSeatRowsController,
                hintText: 'Number of Seat Rows',
                obscureText: false,
                prefixIcon: Icons.event_seat,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: dutyController,
                hintText: 'Duty',
                obscureText: false,
                prefixIcon: Icons.attach_money,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: dateController,
                hintText: 'Date',
                obscureText: false,
                prefixIcon: Icons.date_range,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: deliveryplaceController,
                hintText: 'Delivery Place',
                obscureText: false,
                prefixIcon: Icons.location_on,
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
