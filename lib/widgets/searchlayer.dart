import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/models/spot.dart';
import 'package:finder_v2/providers/categoriesProvider.dart';
import 'package:finder_v2/providers/generalState.dart';
import 'package:finder_v2/screens/LocationReviewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

import '../constants.dart';

class SearchLayer extends StatefulWidget {
  const SearchLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  State<SearchLayer> createState() => _SearchLayerState();
}

class _SearchLayerState extends State<SearchLayer> {
  final initialFuture = FirebaseFirestore.instance.collection('spots').get();
  late Future<QuerySnapshot<Map<String, dynamic>>> currentFuture;

  @override
  void initState() {
    super.initState();
    currentFuture = initialFuture;
  }

  @override
  Widget build(BuildContext context) {
    final categoryProv = Provider.of<CategoriesProvider>(context);
    final screenheight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: screenheight * 0.14 * widget.controller.value,
          width: double.infinity,
          color: mainColor, //.withOpacity(1),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     controller.playReverse(
                  //         duration: Duration(milliseconds: 300));
                  //   },
                  //   child: Text('close'),
                  // ),

                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(30)),
                  //   child: CupertinoSearchTextField(
                  //     onSubmitted: (search) {
                  //       currentFuture = FirebaseFirestore.instance
                  //           .collection('spots')
                  //           .where(FieldPath())
                  //           .get();
                  //     },
                  //   ),
                  //       ),
                  Text(
                    'Filter',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryProv.allCategories.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: ElevatedButton(
                            onPressed: () async {
                              categoryProv.selectedCategories.contains(
                                      categoryProv.allCategories[index])
                                  ? categoryProv.removeCategory(
                                      categoryProv.allCategories[index])
                                  : categoryProv.addCategory(
                                      categoryProv.allCategories[index]);
                              if (categoryProv.selectedCategories.length == 0) {
                                currentFuture = initialFuture;
                              } else {
                                currentFuture = FirebaseFirestore.instance
                                    .collection('spots')
                                    // .where('name', isEqualTo: 'vebes2')
                                    .where('category',
                                        whereIn:
                                            categoryProv.selectedCategories)
                                    .get();
                              }
                            },
                            child: Text(categoryProv.allCategories[index]),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                                backgroundColor: categoryProv.selectedCategories
                                        .contains(
                                            categoryProv.allCategories[index])
                                    ? MaterialStateColor.resolveWith(
                                        (states) => mainColor.withOpacity(0.9))
                                    : MaterialStateColor.resolveWith((states) =>
                                        Colors.grey.withOpacity(1)))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (widget.controller.value == 1)
          Expanded(
              child: GestureDetector(
            onTap: () => widget.controller
                .playReverse(duration: Duration(milliseconds: 300)),
            child: Container(color: Colors.white60),
          )),
        Container(
          height: screenheight * 0.6 * widget.controller.value,
          color: mainColor,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: currentFuture,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) => SearchLayerSpotItem(
                    controller: widget.controller,
                    spot: Spot(
                        id: snapshot.data!.docs[index].id,
                        rating: snapshot.data!.docs[index].data()['rating'],
                        category: snapshot.data!.docs[index].data()['category'],
                        imageUrls: snapshot.data!.docs[index]
                            .data()['imageUrls'] as List,
                        numberOfRatings: snapshot.data!.docs[index]
                            .data()['numberOfRatings'],
                        myPosition: MyPosition(
                            latitude: snapshot.data!.docs[index].data()['lat'],
                            longitube:
                                snapshot.data!.docs[index].data()['lng']),
                        name: snapshot.data!.docs[index].data()['name'])),
              );
            },
          ),
        )
      ],
    );
  }
}

class SearchLayerSpotItem extends StatelessWidget {
  const SearchLayerSpotItem({
    required this.spot,
    required this.controller,
  });
  final Spot spot;
  final AnimationController controller;
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
                  print('cccccccccccccccccccccccccccc');
                  controller.reverse();
                  Provider.of<GeneralState>(context, listen: false).setIt(
                      id: spot.id!,
                      lat: spot.myPosition.latitude,
                      lng: spot.myPosition.longitube);
                },
              }),
          // onTap: () => Navigator.of(context)
          //     .pushNamed(LocationReviewScreen.route, arguments: ),
          // onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //   builder: (BuildContext context) => LocationReviewScreen(
          //     // spot: spot,
          // directFunction: () async {
          //   await controller.reverse();
          //   Provider.of<GeneralState>(context, listen: false).setIt(
          //       id: spot.id!,
          //       lat: spot.myPosition.latitude,
          //       lng: spot.myPosition.longitube);
          // },
          //   ),
          // )),

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
                  backgroundImage: NetworkImage(spot.imageUrls.first),
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
                          await controller.reverse();
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
                    SizedBox(height: 40),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.white.withOpacity(
            0.8,
          ),
        )
      ],
    );
  }
}
