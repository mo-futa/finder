// ignore_for_file: file_names, prefer_const_constructors

import 'package:finder_v2/screens/UserProfileScreen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ListOfSpotMakers extends StatelessWidget {
  static const String route = 'List-of-spotmakers';
  const ListOfSpotMakers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('spot makers'),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (_, index) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(UserProfileScreen.route),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  // height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: mainColor,
                        radius: 30,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'synnonym words',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Icon(
                          //       Icons.restaurant,
                          //       size: 16,
                          //     ),
                          //     SizedBox(
                          //       width: 5,
                          //     ),
                          //     Text('food')
                          //   ],
                          // ),
                          SizedBox(height: 5),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.thumb_up),
                                  SizedBox(height: 10),
                                  Text(
                                    '165',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.thumb_down),
                                  SizedBox(height: 10),
                                  Text(
                                    '165',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              // Expanded(child: Container()),
                            ],
                          )
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Chip(
                        label: Text(
                          '5 spots',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: mainColor.withOpacity(0.5),
                      )
                      // Column(
                      //   children: [
                      //     TextButton(
                      //         onPressed: () {},
                      //         child: Text(
                      //           'Review',
                      //           style: TextStyle(color: mainColor),
                      //         )),
                      //     TextButton(
                      //         onPressed: () {},
                      //         child: Icon(
                      //           Icons.directions,
                      //           color: mainColor,
                      //           // style: TextStyle(color: mainColor),
                      //         )),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                thickness: 2,
                color: Colors.black.withOpacity(
                  0.2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
