// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../constants.dart';

class ProfilePicker extends StatefulWidget {
  ProfilePicker(this.funtion);
  final Function(File file) funtion;
  @override
  _ProfilePickerState createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {
  final ImagePicker _picker = ImagePicker();

  XFile? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          final imagex = await _picker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            image = imagex;
                          });
                          widget.funtion(File(image!.path));
                          print('yes1');
                          Navigator.of(context).pop();
                          print('yes2');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.camera_alt), Text('Camera')],
                        ),
                      ),
                      SizedBox(width: 40),
                      InkWell(
                        onTap: () async {
                          final imagex = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            image = imagex;
                          });
                          widget.funtion(File(image!.path));
                          print('yes1');
                          Navigator.of(context).pop();
                          print('yes2');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.image), Text('Camera')],
                        ),
                      ),
                    ],
                  ),
                )),
        child: Container(
          height: 100,
          width: 100,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle, color: mainColor),
          child: image == null
              ? Center(
                  child: Icon(
                  Icons.camera_alt,
                  size: 70,
                  color: Colors.white,
                ))
              : Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                ),
        ));
  }
}


Future<File> pickImage(ImageSource imageSource) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: imageSource);
  return File(pickedFile!.path);
}

Future<String> uploadFile(BuildContext context, File imageFile) async {
  String fileName = basename(imageFile.path);
  Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  return taskSnapshot.ref.getDownloadURL();
}
