// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:finder_v2/providers/userProvider.dart';
import 'package:finder_v2/screens/make_spot_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BecomeSpotMaker extends StatefulWidget {
  static const String route = 'become-spotmaker';

  @override
  State<BecomeSpotMaker> createState() => _BecomeSpotMakerState();
}

class _BecomeSpotMakerState extends State<BecomeSpotMaker> {
  bool _isSpotMaker = false;
  bool _isLoading = false;

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Switch to become a Spotmaker, you may now set spots and gain revenue for your discoveries your account will now become public and other users will be able to vote your karma(truth) point,so review honestly. have fun",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Switch(
                      value: _isSpotMaker,
                      onChanged: (value) => setState(() {
                        
                       _isSpotMaker = value;
                      }),
                      activeColor: mainColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel')),
                        const SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              final user =
                                  Provider.of<UserProvider>(context,listen: false).user;
                              user.isSpotMaker = _isSpotMaker;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .update(
                                {'isSpotMaker': _isSpotMaker},
                              );
                              Navigator.of(context)
                                  .popAndPushNamed(MakeSpotScreen.route);
                            },
                            child: const Text('done')),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
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
