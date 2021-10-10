// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backGColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            'Administrator page',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: backGColor,
          elevation: 0,
          bottom: const TabBar(tabs: [
            // Text(
            //   'Report',
            //   style: TextStyle(color: Colors.black),
            // ),
            Text(
              'SpotMakers',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Spots',
              style: TextStyle(color: Colors.black),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            //     initialData: null,
            //     future: FirebaseFirestore.instance.collection('reports').get(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState != ConnectionState.done) {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       if (!snapshot.hasData) {
            //         return Center(
            //           child: Text('No reports'),
            //         );
            //       }
            //       return ListView.builder(
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context, index) => ListTile(
            //           tileColor: Colors.white,
            //           title: Text(
            //               "${snapshot.data!.docs[index].data()['content']}"),
            //           trailing: Text(
            //               "${DateTime.parse(snapshot.data!.docs[index].data()['time']).hour}:${DateTime.parse(snapshot.data!.docs[index].data()['time']).minute}"),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                initialData: null,
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('isSpotMaker', isEqualTo: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No SpotMakers'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => ExpansionTile(
                      backgroundColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        backgroundImage: NetworkImage(
                            snapshot.data!.docs[index].data()['imageUrl']),
                      ),
                      title:
                          Text("${snapshot.data!.docs[index].data()['name']}"),
                      children: [
                        SizedBox(
                          height: 150,
                          child: FutureBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            initialData: null,
                            future: FirebaseFirestore.instance
                                .collection('reports')
                                .where('spotMakerId',
                                    isEqualTo: snapshot.data!.docs[index].id)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text('No reports'),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'report count: ${snapshot.data!.docs.length}'),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) => ListTile(
                                        tileColor: Colors.white,
                                        title: Text(
                                            "${snapshot.data!.docs[index].data()['content']}"),
                                        trailing: Text(
                                            "${DateTime.parse(snapshot.data!.docs[index].data()['time']).hour}:${DateTime.parse(snapshot.data!.docs[index].data()['time']).minute}"),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                child: Icon(Icons.delete),
                                onPressed: () async {
                                  // await FirebaseFirestore.instance
                                  //     .collection('users')
                                  //     .doc(snapshot.data!.docs[index].id)
                                  //     .delete();
                                  // final response = await http.post(Uri.parse(
                                  //     'https://us-central1-finder-a92b9.cloudfunctions.net/deleteUser?uid=${snapshot.data!.docs[index].id}'));
                                  // print('xxxxxxxxxxxxxxxxxxxxxxxxxxx2');
                                  // print(response.body);
                                },
                              ),
                              TextButton(
                                  onPressed: () async {
                                    // final Email email = Email(
                                    //   body: 'this spot will be deleted',
                                    //   subject: 'Warning',
                                    //   recipients: [
                                    //     snapshot.data!.docs[index]
                                    //         .data()[snapshot.data!.docs[index].data()['email']]
                                    //   ],
                                    //   // cc: ['cc@example.com'],
                                    //   // bcc: ['bcc@example.com'],
                                    //   // attachmentPaths: ['/path/to/attachment.zip'],
                                    //   isHTML: false,
                                    // );

                                    // await FlutterEmailSender.send(email);
                                  },
                                  child: Icon(Icons.message)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                initialData: null,
                future: FirebaseFirestore.instance.collection('spots').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No spots'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => ExpansionTile(
                      backgroundColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        backgroundImage: NetworkImage(
                            (snapshot.data!.docs[index].data()['imageUrls']
                                    as List)
                                .first),
                      ),
                      title:
                          Text("${snapshot.data!.docs[index].data()['name']}"),
                      children: [
                        SizedBox(
                          height: 150,
                          child: FutureBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            initialData: null,
                            future: FirebaseFirestore.instance
                                .collection('reports')
                                .where('spotId',
                                    isEqualTo: snapshot.data!.docs[index].id)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text('No reports'),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'report count: ${snapshot.data!.docs.length}'),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) => ListTile(
                                        tileColor: Colors.white,
                                        title: Text(
                                            "${snapshot.data!.docs[index].data()['content']}"),
                                        trailing: Text(
                                            "${DateTime.parse(snapshot.data!.docs[index].data()['time']).hour}:${DateTime.parse(snapshot.data!.docs[index].data()['time']).minute}"),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () async {
//                                     await FirebaseFirestore.instance
//                                         .collection('spots')
//                                         .doc(snapshot.data!.docs[index].id)
//                                         .delete();
// //
                                  },
                                  child: Icon(Icons.delete)),
                              TextButton(
                                  onPressed: () async {
                                    // final Email email = Email(
                                    //   body:
                                    //       'Plese reconfirm your locations, various reposts have been made',
                                    //   subject: 'Warning',
                                    //   recipients: [
                                    //     snapshot.data!.docs[index]
                                    //         .data()['email']
                                    //   ],
                                    //   // cc: ['cc@example.com'],
                                    //   // bcc: ['bcc@example.com'],
                                    //   // attachmentPaths: ['/path/to/attachment.zip'],
                                    //   isHTML: false,
                                    // );

                                    // await FlutterEmailSender.send(email);
                                  },
                                  child: Icon(Icons.message)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
