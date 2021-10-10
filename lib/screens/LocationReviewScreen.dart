// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/models/review.dart';
import 'package:finder_v2/models/spot.dart';
import 'package:finder_v2/providers/current_position_provider.dart';
import 'package:finder_v2/providers/generalState.dart';
import 'package:finder_v2/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class LocationReviewScreen extends StatefulWidget {
  static const String route = 'location-review-screen';
  // ignore: use_key_in_widget_constructors
  // const LocationReviewScreen({required this.spot,required this.directFunction});
  // final Spot spot;
  // final Function directFunction;

  @override
  State<LocationReviewScreen> createState() => _LocationReviewScreenState();
}

class _LocationReviewScreenState extends State<LocationReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print('cdcdccdcdcdcdcdcdcdcdcdcdcd');
    print(args);
    final currentPosition =
        Provider.of<CurrentPositionProvider>(context, listen: false).myPosition;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    //qprint('sssssssssssssssssssssssssssssssss${args['spot'].rating}');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: backGColor,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                flex: 4,
                child: PageView.builder(
                  itemCount: args['spot'].imageUrls.length,
                  itemBuilder: (context, index) => Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      color: mainColor,
                      image: DecorationImage(
                          image: NetworkImage(args['spot'].imageUrls[index]),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: TabBar(
                  tabs: const [Text('Details'), Text('Reviews')],
                  labelColor: mainColor,
                  indicatorColor: mainColor,
                  unselectedLabelColor: mainColor.withOpacity(0.5),
                ),
              ),
              Expanded(
                flex: 6,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                args['spot'].name,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: mainColor,
                                ),
                              ),
                              FavoriteButton(spot: args['spot'])
                            ],
                          ),

                          RatingBar.builder(
                            glowColor: backGColor,
                            unratedColor: mainColor.withOpacity(0.3),
                            initialRating: args['spot'].rating == null
                                ? 0
                                : args['spot'].rating!,
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
                            onRatingUpdate: (rating) {
                              // _rating = rating;
                              // print(_rating);
                            },
                          ),

                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.star,
                          //       color: mainColor,
                          //     ),
                          //     Icon(
                          //       Icons.star,
                          //       color: mainColor,
                          //     ),
                          //     Icon(
                          //       Icons.star,
                          //       color: mainColor,
                          //     ),
                          //     Spacer(),
                          //     ElevatedButton(
                          //         onPressed: () {},
                          //         child: Icon(Icons.directions))
                          //   ],
                          // ),

                          SizedBox(height: 20),
                          if (args['spot'].numberOfRatings != null)
                            Text(
                              '${args['spot'].numberOfRatings} reviews',
                              style: TextStyle(color: mainColor, fontSize: 20),
                            ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                '${calculateDistance(currentPosition!.latitude, currentPosition.longitube, args['spot'].myPosition.latitude, args['spot'].myPosition.longitube).toStringAsPrecision(2)} km  away',
                                style:
                                    TextStyle(color: mainColor, fontSize: 20),
                              ),
                              SizedBox(width: 5),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pop();
                                    args['directFunction'];
                                    await Future.delayed(
                                        Duration(milliseconds: 300));
                                    // .pushNamed(MapScreen.route);
                                    Provider.of<GeneralState>(context,
                                            listen: false)
                                        .setIt(
                                            id: args['spot'].id!,
                                            lat: args['spot']
                                                .myPosition
                                                .latitude,
                                            lng: args['spot']
                                                .myPosition
                                                .longitube);
                                  },
                                  child: Icon(
                                    Icons.directions,
                                    color: mainColor,
                                    // style: TextStyle(color: mainColor),
                                  )),
                            ],
                          ),
                          Expanded(child: Container()),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Chip(
                              label: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final _textController =
                                            TextEditingController();
                                        double? _rating;
                                        return AlertDialog(
                                          title: Text('Report Spot'),
                                          content: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                right: -40.0,
                                                top: -40.0,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CircleAvatar(
                                                    child: Icon(Icons.close),
                                                    backgroundColor: mainColor
                                                        .withOpacity(1),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      controller:
                                                          _textController,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      child: Text("Submit"),
                                                      onPressed: () async {
                                                        if (_textController
                                                                .text.isEmpty &&
                                                            _rating == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                        final spotMaker =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'spots')
                                                                .doc(
                                                                    args['spot']
                                                                        .id)
                                                                .get();
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'reports')
                                                            .add({
                                                          'content':
                                                              _textController
                                                                  .text,
                                                          'time': DateTime.now()
                                                              .toIso8601String(),
                                                          'spotId':
                                                              args['spot'].id,
                                                          'spotMakerId':
                                                              spotMaker.data()![
                                                                  'spotMakerId'],
                                                        });

                                                        setState(() {});

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  'Report',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection('reviews')
                                  .where('spotId', isEqualTo: args['spot'].id)
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
                                    child: Text('No reviews yet'),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) => ReviewCard(
                                      review: Review(
                                          date: DateTime.parse(snapshot
                                              .data!.docs[index]
                                              .data()['time']),
                                          rating: snapshot.data!.docs[index]
                                              .data()['rating'],
                                          review: snapshot.data!.docs[index]
                                              .data()['review'],
                                          reviewerName: snapshot
                                              .data!.docs[index]
                                              .data()['reviewerName'],
                                          reviewerImage: snapshot
                                              .data!.docs[index]
                                              .data()['reviewerImage'])),
                                );
                              }),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Chip(
                              label: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final _textController =
                                            TextEditingController();
                                        double? _rating;
                                        return AlertDialog(
                                          title: Text('Add a Review'),
                                          content: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                right: -40.0,
                                                top: -40.0,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CircleAvatar(
                                                    child: Icon(Icons.close),
                                                    backgroundColor: mainColor
                                                        .withOpacity(1),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  RatingBar.builder(
                                                    glowColor: backGColor,
                                                    initialRating: 0,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    itemSize: 20,
                                                    // allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: mainColor,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      _rating = rating;
                                                      print(_rating);
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      controller:
                                                          _textController,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      child: Text("Submit"),
                                                      onPressed: () async {
                                                        if (_textController
                                                                .text.isEmpty &&
                                                            _rating == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'reviews')
                                                            .add({
                                                          'rating': _rating,
                                                          'review':
                                                              _textController
                                                                  .text,
                                                          'time': DateTime.now()
                                                              .toIso8601String(),
                                                          'spotId':
                                                              args['spot'].id,
                                                          'reviewerName':
                                                              user.name,
                                                          'reviewerImage':
                                                              user.imageUrl,
                                                        });
                                                        final res =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'spots')
                                                                .doc(
                                                                    args['spot']
                                                                        .id)
                                                                .get();
                                                        List<num> ratings = [];
                                                        if (res.data()![
                                                                'ratings'] !=
                                                            null) {
                                                          List<dynamic> rr =
                                                              res.data()![
                                                                  'ratings'];
                                                          for (var i = 0;
                                                              i < rr.length;
                                                              i++) {
                                                            ratings.add((rr
                                                                        .first
                                                                    as Map)
                                                                .values
                                                                .first as num);
                                                          }
                                                        }
                                                        print('ffffffffffff');
                                                        print(ratings);

                                                        ratings.add(_rating!);
                                                        num rating = ratings.fold(
                                                                0,
                                                                (num previousValue,
                                                                        num
                                                                            element) =>
                                                                    previousValue +
                                                                    element) /
                                                            ratings.length;
                                                        print(ratings);
                                                        print('rating $rating');
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('spots')
                                                            .doc(
                                                                args['spot'].id)
                                                            .set(
                                                                {
                                                              'rating': rating,
                                                              'numberOfRatings':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                              "ratings": FieldValue
                                                                  .arrayUnion([
                                                                {
                                                                  '${DateTime.now().toIso8601String()}':
                                                                      _rating
                                                                }
                                                              ])
                                                            },
                                                                SetOptions(
                                                                    merge:
                                                                        true));

                                                        setState(() {});

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  'Add a Review',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              backgroundColor: mainColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )

          // CustomScrollView(
          //   slivers: [
          //     // SliverAppBar(
          //     //   pinned: true,
          //     //   expandedHeight: 300,
          //     //   collapsedHeight: 70,
          //     //   flexibleSpace: PageView.builder(
          //     //     itemCount: args['spot'].imageUrls.length,
          //     //     itemBuilder: (context, index) => Container(
          //     //       // ignore: prefer_const_constructors
          //     //       decoration: BoxDecoration(
          //     //         color: mainColor,
          //     //         image: DecorationImage(
          //     //             image: NetworkImage(args['spot'].imageUrls[index]),
          //     //             fit: BoxFit.cover),
          //     //       ),
          //     //     ),
          //     //   ),
          //     //   // Image.asset(
          //     //   //   'assets/pic1.png',
          //     //   //   fit: BoxFit.cover,
          //     //   // ),
          //     //   automaticallyImplyLeading: true,
          //     //   bottom: TabBar(
          //     //     tabs: const [
          //     //       Text(
          //     //         'Details',
          //     //         style: TextStyle(
          //     //           fontSize: 20,
          //     //           // color: mainColor.withOpacity(0.5),
          //     //         ),
          //     //       ),
          //     //       Text(
          //     //         'Comments',
          //     //         style: TextStyle(
          //     //           fontSize: 20,
          //     //           // color: mainColor.withOpacity(0.5),
          //     //         ),
          //     //       ),
          //     //     ],
          //     //     indicatorColor: Colors.white,
          //     //     labelColor: Colors.white,
          //     //     unselectedLabelColor: Colors.white.withOpacity(0.5),
          //     //   ),
          //     // ),
          //     SliverFillRemaining(
          //       child: Expanded(
          //         child: TabBarView(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(20.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     mainAxisSize: MainAxisSize.max,
          //                     children: [
          //                       Text(
          //                         args['spot'].name,
          //                         style: TextStyle(
          //                           fontSize: 28,
          //                           color: mainColor,
          //                         ),
          //                       ),
          //                       FavoriteButton(spot: args['spot'])
          //                     ],
          //                   ),
          //                   RatingBar.builder(
          //                     glowColor: backGColor,
          //                     unratedColor: mainColor.withOpacity(0.3),
          //                     initialRating: args['spot'].rating == null
          //                         ? 0
          //                         : args['spot'].rating!,
          //                     minRating: 0,
          //                     direction: Axis.horizontal,
          //                     itemSize: 20,
          //                     // allowHalfRating: true,
          //                     itemCount: 5,
          //                     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //                     itemBuilder: (context, _) => Icon(
          //                       Icons.star,
          //                       color: mainColor,
          //                     ),
          //                     onRatingUpdate: (rating) {
          //                       // _rating = rating;
          //                       // print(_rating);
          //                     },
          //                   ),
          //                   // Row(
          //                   //   children: [
          //                   //     Icon(
          //                   //       Icons.star,
          //                   //       color: mainColor,
          //                   //     ),
          //                   //     Icon(
          //                   //       Icons.star,
          //                   //       color: mainColor,
          //                   //     ),
          //                   //     Icon(
          //                   //       Icons.star,
          //                   //       color: mainColor,
          //                   //     ),
          //                   //     Spacer(),
          //                   //     ElevatedButton(
          //                   //         onPressed: () {},
          //                   //         child: Icon(Icons.directions))
          //                   //   ],
          //                   // ),
          //                   SizedBox(height: 20),
          //                   if (args['spot'].numberOfRatings != null)
          //                     Text(
          //                       '${args['spot'].numberOfRatings} reviews',
          //                       style: TextStyle(color: mainColor, fontSize: 20),
          //                     ),
          //                   SizedBox(height: 20),
          //                   Row(
          //                     children: [
          //                       Text(
          //                         '${calculateDistance(currentPosition!.latitude, currentPosition.longitube, args['spot'].myPosition.latitude, args['spot'].myPosition.longitube).toStringAsPrecision(2)} km  away',
          //                         style:
          //                             TextStyle(color: mainColor, fontSize: 20),
          //                       ),
          //                       SizedBox(width: 5),
          //                       TextButton(
          //                           onPressed: () async {
          //                             Navigator.of(context).pop();
          //                             // Navigator.of(context).pop();
          //                             print('fffffffffffffffffff1');
          //                             args['directFunction']();
          //                             print('fffffffffffffffffff2');
          //                             await Future.delayed(
          //                                 Duration(milliseconds: 300));
          //                             // .pushNamed(MapScreen.route);
          //                             Provider.of<GeneralState>(context,
          //                                     listen: false)
          //                                 .setIt(
          //                                     id: args['spot'].id!,
          //                                     lat:
          //                                         args['spot'].myPosition.latitude,
          //                                     lng: args['spot'].myPosition.longitube);
          //                           },
          //                           child: Icon(
          //                             Icons.directions,
          //                             color: mainColor,
          //                             // style: TextStyle(color: mainColor),
          //                           )),
          //                     ],
          //                   ),
          //                   Expanded(child: Container()),
          //                   Align(
          //                     alignment: Alignment.bottomRight,
          //                     child: Chip(
          //                       label: TextButton(
          //                         onPressed: () {
          //                           showDialog(
          //                               context: context,
          //                               builder: (BuildContext context) {
          //                                 final _textController =
          //                                     TextEditingController();
          //                                 double? _rating;
          //                                 return AlertDialog(
          //                                   title: Text('Report Spot'),
          //                                   content: Stack(
          //                                     children: <Widget>[
          //                                       Positioned(
          //                                         right: -40.0,
          //                                         top: -40.0,
          //                                         child: InkResponse(
          //                                           onTap: () {
          //                                             Navigator.of(context).pop();
          //                                           },
          //                                           child: CircleAvatar(
          //                                             child: Icon(Icons.close),
          //                                             backgroundColor: mainColor
          //                                                 .withOpacity(1),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       Column(
          //                                         mainAxisSize: MainAxisSize.min,
          //                                         children: <Widget>[
          //                                           Padding(
          //                                             padding:
          //                                                 EdgeInsets.all(8.0),
          //                                             child: TextField(
          //                                               controller:
          //                                                   _textController,
          //                                             ),
          //                                           ),
          //                                           Padding(
          //                                             padding:
          //                                                 const EdgeInsets.all(
          //                                                     8.0),
          //                                             child: ElevatedButton(
          //                                               child: Text("Submit"),
          //                                               onPressed: () async {
          //                                                 if (_textController
          //                                                         .text.isEmpty &&
          //                                                     _rating == null) {
          //                                                   Navigator.of(context)
          //                                                       .pop();
          //                                                 }
          //                                                 final spotMaker =
          //                                                     await FirebaseFirestore
          //                                                         .instance
          //                                                         .collection(
          //                                                             'spots')
          //                                                         .doc(args['spot'].id)
          //                                                         .get();
          //                                                 await FirebaseFirestore
          //                                                     .instance
          //                                                     .collection(
          //                                                         'reports')
          //                                                     .add({
          //                                                   'content':
          //                                                       _textController
          //                                                           .text,
          //                                                   'time': DateTime.now()
          //                                                       .toIso8601String(),
          //                                                   'spotId':
          //                                                       args['spot'].id,
          //                                                   'spotMakerId':
          //                                                       spotMaker.data()![
          //                                                           'spotMakerId'],
          //                                                 });
          //                                                 setState(() {});
          //                                                 Navigator.of(context)
          //                                                     .pop();
          //                                               },
          //                                             ),
          //                                           )
          //                                         ],
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 );
          //                               });
          //                         },
          //                         child: Text(
          //                           'Report',
          //                           style: TextStyle(color: Colors.white),
          //                         ),
          //                       ),
          //                       backgroundColor: Colors.blue,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(10.0),
          //               child: Stack(
          //                 fit: StackFit.expand,
          //                 children: [
          //                   FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          //                       future: FirebaseFirestore.instance
          //                           .collection('reviews')
          //                           .where('spotId', isEqualTo: args['spot'].id)
          //                           .get(),
          //                       builder: (context, snapshot) {
          //                         if (snapshot.connectionState !=
          //                             ConnectionState.done) {
          //                           return Center(
          //                             child: CircularProgressIndicator(),
          //                           );
          //                         }
          //                         if (!snapshot.hasData) {
          //                           return Center(
          //                             child: Text('No reviews yet'),
          //                           );
          //                         }
          //                         return ListView.builder(
          //                           itemCount: snapshot.data!.docs.length,
          //                           itemBuilder: (context, index) => ReviewCard(
          //                               review: Review(
          //                                   date: DateTime.parse(snapshot
          //                                       .data!.docs[index]
          //                                       .data()['time']),
          //                                   rating: snapshot.data!.docs[index]
          //                                       .data()['rating'],
          //                                   review: snapshot.data!.docs[index]
          //                                       .data()['review'],
          //                                   reviewerName: snapshot
          //                                       .data!.docs[index]
          //                                       .data()['reviewerName'],
          //                                   reviewerImage: snapshot
          //                                       .data!.docs[index]
          //                                       .data()['reviewerImage'])),
          //                         );
          //                       }),
          //                   Align(
          //                     alignment: Alignment.bottomRight,
          //                     child: Chip(
          //                       label: TextButton(
          //                         onPressed: () {
          //                           showDialog(
          //                               context: context,
          //                               builder: (BuildContext context) {
          //                                 final _textController =
          //                                     TextEditingController();
          //                                 double? _rating;
          //                                 return AlertDialog(
          //                                   title: Text('Add a Review'),
          //                                   content: Stack(
          //                                     children: <Widget>[
          //                                       Positioned(
          //                                         right: -40.0,
          //                                         top: -40.0,
          //                                         child: InkResponse(
          //                                           onTap: () {
          //                                             Navigator.of(context).pop();
          //                                           },
          //                                           child: CircleAvatar(
          //                                             child: Icon(Icons.close),
          //                                             backgroundColor: mainColor
          //                                                 .withOpacity(1),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       Column(
          //                                         mainAxisSize: MainAxisSize.min,
          //                                         children: <Widget>[
          //                                           RatingBar.builder(
          //                                             glowColor: backGColor,
          //                                             initialRating: 0,
          //                                             minRating: 0,
          //                                             direction: Axis.horizontal,
          //                                             itemSize: 20,
          //                                             // allowHalfRating: true,
          //                                             itemCount: 5,
          //                                             itemPadding:
          //                                                 EdgeInsets.symmetric(
          //                                                     horizontal: 4.0),
          //                                             itemBuilder: (context, _) =>
          //                                                 Icon(
          //                                               Icons.star,
          //                                               color: mainColor,
          //                                             ),
          //                                             onRatingUpdate: (rating) {
          //                                               _rating = rating;
          //                                               print(_rating);
          //                                             },
          //                                           ),
          //                                           Padding(
          //                                             padding:
          //                                                 EdgeInsets.all(8.0),
          //                                             child: TextField(
          //                                               controller:
          //                                                   _textController,
          //                                             ),
          //                                           ),
          //                                           Padding(
          //                                             padding:
          //                                                 const EdgeInsets.all(
          //                                                     8.0),
          //                                             child: ElevatedButton(
          //                                               child: Text("Submit"),
          //                                               onPressed: () async {
          //                                                 if (_textController
          //                                                         .text.isEmpty &&
          //                                                     _rating == null) {
          //                                                   Navigator.of(context)
          //                                                       .pop();
          //                                                 }
          //                                                 await FirebaseFirestore
          //                                                     .instance
          //                                                     .collection(
          //                                                         'reviews')
          //                                                     .add({
          //                                                   'rating': _rating,
          //                                                   'review':
          //                                                       _textController
          //                                                           .text,
          //                                                   'time': DateTime.now()
          //                                                       .toIso8601String(),
          //                                                   'spotId':
          //                                                       args['spot'].id,
          //                                                   'reviewerName':
          //                                                       user.name,
          //                                                   'reviewerImage':
          //                                                       user.imageUrl,
          //                                                 });
          //                                                 final res =
          //                                                     await FirebaseFirestore
          //                                                         .instance
          //                                                         .collection(
          //                                                             'spots')
          //                                                         .doc(args['spot'].id)
          //                                                         .get();
          //                                                 List<num> ratings = [];
          //                                                 if (res.data()![
          //                                                         'ratings'] !=
          //                                                     null) {
          //                                                   List<dynamic> rr =
          //                                                       res.data()![
          //                                                           'ratings'];
          //                                                   for (var i = 0;
          //                                                       i < rr.length;
          //                                                       i++) {
          //                                                     ratings.add((rr
          //                                                                 .first
          //                                                             as Map)
          //                                                         .values
          //                                                         .first as num);
          //                                                   }
          //                                                 }
          //                                                 print('ffffffffffff');
          //                                                 print(ratings);
          //                                                 ratings.add(_rating!);
          //                                                 num rating = ratings.fold(
          //                                                         0,
          //                                                         (num previousValue,
          //                                                                 num
          //                                                                     element) =>
          //                                                             previousValue +
          //                                                             element) /
          //                                                     ratings.length;
          //                                                 print(ratings);
          //                                                 print('rating $rating');
          //                                                 await FirebaseFirestore
          //                                                     .instance
          //                                                     .collection('spots')
          //                                                     .doc(args['spot'].id)
          //                                                     .set(
          //                                                         {
          //                                                       'rating': rating,
          //                                                       'numberOfRatings':
          //                                                           FieldValue
          //                                                               .increment(
          //                                                                   1),
          //                                                       "ratings": FieldValue
          //                                                           .arrayUnion([
          //                                                         {
          //                                                           '${DateTime.now().toIso8601String()}':
          //                                                               _rating
          //                                                         }
          //                                                       ])
          //                                                     },
          //                                                         SetOptions(
          //                                                             merge:
          //                                                                 true));
          //                                                 setState(() {});
          //                                                 Navigator.of(context)
          //                                                     .pop();
          //                                               },
          //                                             ),
          //                                           )
          //                                         ],
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 );
          //                               });
          //                         },
          //                         child: Text(
          //                           'Add a Review',
          //                           style: TextStyle(color: Colors.white),
          //                         ),
          //                       ),
          //                       backgroundColor: mainColor,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // ),

          ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key? key,
    required this.spot,
  }) : super(key: key);

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox();
          }
          if ((snapshot.data!.data()!['favorites'] as List<dynamic>)
              .contains(spot.id)) {
            return ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => mainColor.withOpacity(0.5))),
                child: Text('favourite'));
          }
          return ElevatedButton(
              onPressed: () async {
                print('hapen');
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id)
                    .set({
                  "favorites": FieldValue.arrayUnion([spot.id])
                }, SetOptions(merge: true));
                user.favorites!.add(spot.id);
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => mainColor)),
              child: Text('add to favorites'));
        });
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: mainColor,
              backgroundImage: NetworkImage(review.reviewerImage),
            ),
            title: Text(
              review.reviewerName,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            subtitle: RatingBar.builder(
              ignoreGestures: true,
              glowColor: backGColor,
              // unratedColor: Colors.transparent,
              initialRating: review.rating,
              // minRating: 0,
              direction: Axis.horizontal,
              itemSize: 20,
              // allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: mainColor,
              ),
              onRatingUpdate: (rating) {
                // _rating = rating;
                // print(_rating);
              },
            ),

            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: const [
            //     Icon(
            //       Icons.star,
            //       color: mainColor,
            //     ),
            //     Icon(
            //       Icons.star,
            //     ),
            //     Icon(Icons.star),
            //     Icon(Icons.star),
            //     Icon(Icons.star),
            //   ],
            // ),

            trailing: Text(
              '${review.date.day}/${review.date.month}/${review.date.year}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(padding: EdgeInsets.all(15), child: Text(review.review))
        ],
      ),
    );
  }
}
