// ignore_for_file: prefer_const_constructors, file_names

import 'package:finder_v2/providers/current_position_provider.dart';
import 'package:finder_v2/providers/userProvider.dart';
import 'package:finder_v2/screens/make_spot_screen.dart';
import 'package:finder_v2/widgets/maplayer.dart';
import 'package:finder_v2/widgets/searchlayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import '../constants.dart';
import 'ListOfSpotMakers.dart';
import 'UserProfileScreen.dart';
import 'about_screen.dart';
import 'becomeSpotMaker.dart';

class MapScreen extends StatefulWidget {
  static const String route = 'map-screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AnimationMixin {
  // late ScrollController _scrollController;
  late double screenheight;
  late Animation<double> topDrop;

  @override
  void initState() {
    super.initState();
    topDrop = 0.0.tweenTo(1.0).animatedBy(controller);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        color: backGColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: mainColor,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome',
                style: TextStyle(fontSize: 20, color: mainColor),
              ),
              Text(
                user.name,
                style: TextStyle(fontSize: 30, color: mainColor),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text(
                  'My Profile',
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(UserProfileScreen.route),
              ),
              // ElevatedButton(
              //   child: Text(
              //     'Spot Makers',
              //   ),
              //   onPressed: () =>
              //       Navigator.of(context).pushNamed(ListOfSpotMakers.route),
              // ),
              // SizedBox(height: 40),
              ElevatedButton(
                child: Text(
                  'Log out',
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
              ElevatedButton(
                child: Text(
                  'About',
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AboutScreen.route),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          MapLayer(), 
          // Container(
          //   color: Colors.grey,
          // ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        color: mainColor,
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: Icon(Icons.menu),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.play(duration: Duration(milliseconds: 300));
                      },
                      child: Text('Find'),
                    )
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final myPostion = Provider.of<CurrentPositionProvider>(
                                context,
                                listen: false)
                            .myPosition;
                        print('ssssssssssssssssssssssfrom new page $myPostion');
                        if (Provider.of<UserProvider>(context, listen: false)
                                .user
                                .isSpotMaker ==
                            true) {
                          Navigator.of(context).pushNamed(MakeSpotScreen.route);
                        } else {
                          Navigator.of(context)
                              .pushNamed(BecomeSpotMaker.route);
                        }
                      },
                      child: Icon(Icons.location_pin),
                      // icon: Icon(Icons.location_on),
                      // label: Text('Current Location')
                    )
                  ],
                )
              ],
            ),
          ),
          SearchLayer(
            controller: controller,
          )
        ],
      ),
    );
  }
}
