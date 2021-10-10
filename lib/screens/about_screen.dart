import 'package:flutter/material.dart';

import '../constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const String route = 'About-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('About'),
        // centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: backGColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Finder aims to help you find awesome location that arent prominent enough to be listed on googles official map. You can also join the effort to map out all such location for a share of the ad revenue",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
