// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/providers/categoriesProvider.dart';
import 'package:finder_v2/providers/current_position_provider.dart';
import 'package:finder_v2/providers/userProvider.dart';
import 'package:finder_v2/widgets/multi_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'UserProfileScreen.dart';

class MakeSpotScreen extends StatefulWidget {
  static const String route = 'make-spot-screen';

  MakeSpotScreen({Key? key}) : super(key: key);

  @override
  State<MakeSpotScreen> createState() => _MakeSpotScreenState();
}

class _MakeSpotScreenState extends State<MakeSpotScreen> {
  List<File>? _images;

  List<String>? imageUrls;

  String? name, category;

  bool? imageSet, nameSet, categorySet;

  bool isLoading = false;

  TextEditingController _textEditingController = TextEditingController();

  void saveFunction(BuildContext context) async {
    if (_images == null) {
      imageSet = false;
      return;
    }
    if (_textEditingController.text.isEmpty) {
      nameSet = false;
      return;
    }
    if (category == null) {
      categorySet = false;
      return;
    }
    setState(() {
      isLoading = true;
    });
    final myPosition =
        Provider.of<CurrentPositionProvider>(context, listen: false)
            .myPosition!;
    imageUrls = await uploadFiles(context, _images!);
    name = _textEditingController.text.trim();
    await FirebaseFirestore.instance.collection('spots').add({
      'name': name,
      'category': category,
      'imageUrls': imageUrls,
      'lat': myPosition.latitude,
      'lng': myPosition.longitube,
      'spotMakerId': Provider.of<UserProvider>(context, listen: false).user.id
    });
    setState(() {
      isLoading = false;
    });
    
    Navigator.of(context).popAndPushNamed(UserProfileScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backGColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Spot your current location",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        MultiImagePicker(callBack: (images) {
                          _images = images;
                        }),
                        if (imageSet == false)
                          Text(
                            'please provide an image',
                            style: TextStyle(color: Colors.red),
                          ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Add image',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        if (imageSet == false)
                          Text(
                            'please provide an image',
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 10),
                        Text(
                          'Category',
                          style: TextStyle(fontSize: 18),
                        ),
                        // ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        //   itemBuilder: (context, index) => ElevatedButton(
                        //       onPressed: () {
                        //         category = 'food';
                        //       },
                        //       child: Text('food')),
                        //   itemCount: 10,
                        // ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: Provider.of<CategoriesProvider>(context,
                                      listen: false)
                                  .allCategories
                                  .map(
                                    (cat) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ElevatedButton(
                                          onPressed: () => setState(() {
                                                category = cat;
                                              }),
                                          child: Text(cat),
                                          style: ButtonStyle(
                                              backgroundColor: cat == category
                                                  ? MaterialStateColor
                                                      .resolveWith((states) =>
                                                          mainColor
                                                              .withOpacity(0.9))
                                                  : MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.grey
                                                              .withOpacity(
                                                                  0.8)))),
                                    ),
                                  )
                                  .toList()),
                        ),

                        if (categorySet == false)
                          Text(
                            'please choose a category',
                            style: TextStyle(color: Colors.red),
                          ),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Cancel')),
                            SizedBox(width: 20),
                            ElevatedButton(
                                onPressed: () => saveFunction(context),
                                child: Text('done')),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Padding(
                        //   padding: const EdgeInsets.all(20.0),
                        // child: Text(
                        //   "fill spotmaker form, you may now set spots and gain revenue for your discoveries your account will now become public and other users will be able to vote your karma(truth) point,so review honestly. have fun",
                        //   textAlign: TextAlign.start,
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ElevatedButton(
                        //         onPressed: () => Navigator.of(context).pop(),
                        //         child: Text('Cancel')),
                        //     SizedBox(width: 20),
                        //     ElevatedButton(
                        //         onPressed: () => Navigator.of(context).pop(),
                        //         child: Text('done')),
                        //   ],
                        // ),
                        // SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
              color: Colors.grey.withOpacity(0.2),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              )),
      ],
    );
  }
}
