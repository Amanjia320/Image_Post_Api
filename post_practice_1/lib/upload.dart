// ignore_for_file: unused_field, non_constant_identifier_names, avoid_print, unnecessary_new, unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image; // This will store the selected image file
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    // ignore: unused_local_variable
    final PickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (PickedFile != null) {
      image = File(PickedFile.path);
      setState(() {});
    } else {
      print('no image is selected');
    }
  }

  Future<void> Upload() async {
    setState(() {
      showSpinner = true;
    });

    // ignore: unused_local_variable
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();
    // ignore: unused_local_variable
    var length = await image!.length();
    // ignore: unused_local_variable
    var uri = Uri.parse('https://fakestoreapi.com/products');
    // ignore: unused_local_variable
    var request = new http.MultipartRequest('POST', uri);

    request.fields['title'] = "Static title";

    // ignore: unused_local_variable
    var multipart = new http.MultipartFile('image', stream, length);

    request.files.add(multipart);
    // ignore: unused_local_variable
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Upload Succesfully');

      setState(() {
        showSpinner = false;
        image = null;
      });
    } else {
      print('failed');
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'POST API',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  getImage();
                },
                child: Container(
                  child: image == null
                      ? const Center(
                          child: Text(
                            'Pick Image',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 21),
                          ),
                        )
                      // ignore: avoid_unnecessary_containers
                      : Container(
                          child: Center(
                            child: Image.file(
                              File(image!.path).absolute,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ), // Show image to the user.
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              InkWell(
                onTap: () {
                  Upload();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.lightBlue,
                  child: const Center(
                    child: Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
