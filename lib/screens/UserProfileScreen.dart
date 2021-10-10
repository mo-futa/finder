// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/models/spot.dart';
import 'package:finder_v2/providers/categoriesProvider.dart';
import 'package:finder_v2/providers/generalState.dart';
import 'package:finder_v2/providers/userProvider.dart';

import 'package:finder_v2/screens/LocationReviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class UserProfileScreen extends StatelessWidget {
  static const String route = 'user-profile-screen';
  // const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: mainColor,
            )),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: backGColor,
      body: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: mainColor,
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 70,
              ),
              if (user.isSpotMaker)
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
          SizedBox(height: 10),
          Text(
            user.name,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5),
          Text('emial/number'),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              // height: 200,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: DefaultTabController(
                length: user.isSpotMaker ? 2 : 1,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        if (user.isSpotMaker)
                          Text(
                            'My Spots',
                            style: TextStyle(
                              fontSize: 20,
                              // color: mainColor.withOpacity(0.5),
                            ),
                          ),
                        Text(
                          'Favorites',
                          style: TextStyle(
                            fontSize: 20,
                            // color: mainColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                      indicatorColor: mainColor,
                      labelColor: mainColor.withOpacity(1),
                      unselectedLabelColor: mainColor.withOpacity(0.5),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          if (user.isSpotMaker)
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection('spots')
                                  .where('spotMakerId', isEqualTo: user.id)
                                  .get(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, index) => ProfileScreenSpotItem(
                                      spot: Spot(
                                          id: snapshot.data!.docs[index].id,
                                          rating: snapshot.data!.docs[index]
                                              .data()['rating'],
                                          category: snapshot.data!.docs[index]
                                              .data()['category'],
                                          imageUrls: snapshot.data!.docs[index]
                                              .data()['imageUrls'] as List,
                                          myPosition: MyPosition(
                                              latitude: snapshot.data!.docs[index]
                                                  .data()['lat'],
                                              longitube: snapshot.data!.docs[index]
                                                  .data()['lng']),
                                          name: snapshot.data!.docs[index]
                                              .data()['name'])),
                                );
                              },
                            ),
                          if (user.favorites!.isEmpty)
                            Center(
                              child: Text('No favorites selected'),
                            ),
                          if (!user.favorites!.isEmpty)
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection('spots')
                                  .where(FieldPath.documentId,
                                      whereIn: user.favorites)
                                  .get(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, index) => ProfileScreenSpotItem(
                                      spot: Spot(
                                          numberOfRatings: snapshot
                                              .data!.docs[index]
                                              .data()['numberOfRatings'],
                                          id: snapshot.data!.docs[index].id,
                                          rating: snapshot.data!.docs[index]
                                              .data()['rating'],
                                          category: snapshot.data!.docs[index]
                                              .data()['category'],
                                          imageUrls: snapshot.data!.docs[index]
                                              .data()['imageUrls'] as List,
                                          myPosition: MyPosition(
                                              latitude: snapshot.data!.docs[index]
                                                  .data()['lat'],
                                              longitube: snapshot.data!.docs[index]
                                                  .data()['lng']),
                                          name: snapshot.data!.docs[index].data()['name'])),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileScreenSpotItem extends StatelessWidget {
  const ProfileScreenSpotItem({
    required this.spot,
  });
  final Spot spot;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, LocationReviewScreen.route,
              arguments: {
                'spot': spot,
                'directFunction': () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              }),

          // // Navigator.of(context).push(
          // //   MaterialPageRoute(
          // //     builder: (BuildContext context) => LocationReviewScreen(
          // //     //   directFunction: (){
          // //     //   Navigator.of(context).pop();
          // //     //   Navigator.of(context).pop();
          // //     // },
          // //     //   spot: spot,
          // //     ),
          // //   ),
          // ),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            // height: 200,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: mainColor,
                  radius: 30,
                  backgroundImage: NetworkImage(spot.imageUrls.first as String),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //fix this
                        CategoriesProvider.getCategoryIcon(spot.category),
                        SizedBox(
                          width: 5,
                        ),
                        Text(spot.category)
                      ],
                    ),
                    SizedBox(height: 5),
                    if (spot.rating == null) Text('No ratings yet'),
                    if (spot.rating != null)
                      RatingBar.builder(
                        glowColor: backGColor, ignoreGestures: true,
                        initialRating: spot.rating!,
                        minRating: 0,
                        direction: Axis.horizontal,
                        itemSize: 20,
                        // allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: mainColor,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    // TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'Review',
                    //       style: TextStyle(color: mainColor),
                    //     )),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          await Future.delayed(Duration(milliseconds: 300));
                          // .pushNamed(MapScreen.route);
                          Provider.of<GeneralState>(context, listen: false)
                              .setIt(
                                  id: spot.id!,
                                  lat: spot.myPosition.latitude,
                                  lng: spot.myPosition.longitube);
                        },
                        child: Icon(
                          Icons.directions,
                          color: mainColor,
                          // style: TextStyle(color: mainColor),
                        )),
                    SizedBox(height: 30),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.black.withOpacity(
            0.2,
          ),
        )
      ],
    );
  }
}
