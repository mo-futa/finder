import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/models/spot.dart';
import 'package:finder_v2/providers/current_position_provider.dart';
import 'package:finder_v2/providers/generalState.dart';
import 'package:finder_v2/screens/LocationReviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapLayer extends StatefulWidget {
  @override
  State<MapLayer> createState() => MapLayerState();
}

class MapLayerState extends State<MapLayer> {
//   // Object for PolylinePoints
//   PolylinePoints? polylinePoints;
// // List of coordinates to join
//   List<LatLng> polylineCoordinates = [];
// // Map storing polylines created by connecting
// // two points
//   Map<PolylineId, Polyline> polylines = {};
// // Create the polylines for showing the route between two places
//   createPolylines(LatLng start, LatLng destination) async {
//     print('weeeeeeeeeeeeeeeeeeeeeeeee');
//     // Initializing PolylinePoints
//     polylinePoints = PolylinePoints();
//     print(1);
//     // Generating the list of coordinates to be used for
//     // drawing the polylines
//     PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
//       'AIzaSyDoITyzHg4KJ4SspHHaL0HuFybrYbdLTlk', // Google Maps API Key
//       PointLatLng(start.latitude, start.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//       travelMode: TravelMode.transit,
//     );
//     print(result.status);
//     // Adding the coordinates to the list
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     print(3);
//     // Defining an ID
//     PolylineId id = PolylineId('poly');
//     // Initializing Polyline
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.green,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     print(4);
//     // Adding the polyline to the map
//     polylines[id] = polyline;
  // }

  void highlightMarker(
      {required String id, required double lat, required double lng}) async {
    print(const MarkerId('3BXXVRHBOH6E1zqg7pCp'));
    final cont = await _controller.future;
    cont.showMarkerInfoWindow(MarkerId(id));
    cont.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  late String _mapStyle;
  final customMarkers = CustomMarkers();
  // ignore: non_constant_identifier_names
  CameraPosition? _initialLocation;
  // late Position position;
  // bool userNavigating = false;
  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
    customMarkers.initialize();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<CurrentPositionProvider>(context);
    final stprov = Provider.of<GeneralState>(context);

    stprov.addListener(() {
      final st = stprov.getIt!;
      highlightMarker(id: st.id, lat: st.lat, lng: st.lng);
    });
    return Stack(
      children: [
        if (_initialLocation != null)
          GoogleMap(
            // mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            // polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: _initialLocation!,
            // onTap:
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (cameraposition) async {
              if (((cameraposition.target.latitude).abs() -
                              (Provider.of<CurrentPositionProvider>(context,
                                          listen: false)
                                      .myPosition!
                                      .latitude)
                                  .abs())
                          .abs() >
                      0.015 ||
                  ((cameraposition.target.longitude).abs() -
                              (Provider.of<CurrentPositionProvider>(context,
                                          listen: false)
                                      .myPosition!
                                      .longitube)
                                  .abs())
                          .abs() >
                      0.01) {
                //extract he items
                final spots =
                    await FirebaseFirestore.instance.collection('spots').get();
                //remove the ones laredy in
                spots.docs.removeWhere((spot) => _markers
                    .any((marker) => spot.id == marker.markerId.toString()));
                print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
                print(spots.docs.length);
                //add the rest
                _markers.addAll(spots.docs.map((element) {
                  return Marker(
                      markerId: MarkerId(element.id),
                      position:
                          LatLng(element.data()['lat'], element.data()['lng']),
                      infoWindow: InfoWindow(
                        title: element.data()['name'],
                        onTap: () => Navigator.pushNamed(
                          context,
                          LocationReviewScreen.route,
                          arguments: {
                            'spot': Spot(
                              category: element.data()['category'],
                              imageUrls: element.data()['imageUrls'],
                              myPosition: MyPosition(
                                  latitude: element.data()['lat'],
                                  longitube: element.data()['lng']),
                              name: element.data()['name'],
                              numberOfRatings:
                                  element.data()['numberOfRatings'],
                              id: element.id,
                              rating: element.data()['rating'],
                            ),
                            'directFunction': () {},
                          },
                        ),
                        // onTap: () => Navigator.of(context)
                        //     .pushNamed(LocationReviewScreen.route, arguments: {
                        //   'spot':
                        // }),
                        // onTap: () => Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         LocationReviewScreen(
                        //       //     directFunction: (){},
                        // spot: Spot(
                        //   category: element.data()['category'],
                        //   imageUrls: element.data()['imageUrls'],
                        //   myPosition: MyPosition(
                        //       latitude: element.data()['lat'],
                        //       longitube: element.data()['lng']),
                        //   name: element.data()['name'],
                        //   numberOfRatings:
                        //       element.data()['numberOfRatings'],
                        //   id: element.id,
                        //   rating: element.data()['rating'],
                        // ),

                        //     ),
                        //   ),
                        // ),
                      ),
                      icon:
                          customMarkers.getMarker(element.data()['category']));
                }));
                setState(() {});
              }
// _markers.add('value')
            },
            markers: _markers,
            onMapCreated: (GoogleMapController controller) async {
              print(_mapStyle);
              _controller.complete(controller);
              await _setmapStyle();
              final firstpos = await Geolocator.getCurrentPosition();
              Provider.of<CurrentPositionProvider>(context, listen: false)
                  .setPosition(
                      myPosition: MyPosition(
                          latitude: firstpos.latitude,
                          longitube: firstpos.longitude));

              FirebaseFirestore.instance
                  .collection('spots')
                  .snapshots()
                  .listen((snapshot) {
                // print(snapshot.docs.length);
                _markers.addAll(snapshot.docs.map((element) {
                  return Marker(
                      markerId: MarkerId(element.id),
                      // onTap: () {
                      //   createPolylines();
                      // },
                      position:
                          LatLng(element.data()['lat'], element.data()['lng']),
                      infoWindow: InfoWindow(
                        title: element.data()['name'],
                        onTap: () => Navigator.pushNamed(
                          context,
                          LocationReviewScreen.route,
                          arguments: {
                            'spot': Spot(
                              category: element.data()['category'],
                              imageUrls: element.data()['imageUrls'],
                              myPosition: MyPosition(
                                  latitude: element.data()['lat'],
                                  longitube: element.data()['lng']),
                              name: element.data()['name'],
                              numberOfRatings:
                                  element.data()['numberOfRatings'],
                              id: element.id,
                              rating: element.data()['rating'],
                            ),
                            'directFunction': () {},
                          },
                        ),
                      ),
                      icon:
                          customMarkers.getMarker(element.data()['category']));
                }));
              });

              //     .where('lat',
              //         isGreaterThan:
              //             currentPosition.myPosition!.latitude - 0.02)
              //     .where('lat',
              //         isLessThan: currentPosition.myPosition!.latitude + 0.02)
              //     .get();
              // final spots1 = await FirebaseFirestore.instance
              //     .collection('spots')
              //     .where('lng',
              //         isGreaterThan:
              //             currentPosition.myPosition!.longitube - 0.02)
              //     .where('lng',
              //         isLessThan: currentPosition.myPosition!.longitube + 0.02)
              //     .get();
              // spots.docs.removeWhere((element) =>
              //     spots1.docs.any((element1) => element.id != element1.id));

              //cant query(with inequality) two fields at one time
              //this means spots will give u all the locations along that vertical strip of the planet
              //and spots1 will give u along the horizontaal strip of the planet
              //and then ill remove the ones that dont appear in both

              // setState(() {});
              print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
              print(_markers.length);
              PolylineResult result =
                  await PolylinePoints().getRouteBetweenCoordinates(
                'AIzaSyDoITyzHg4KJ4SspHHaL0HuFybrYbdLTlk', // Google Maps API Key
                PointLatLng(firstpos.latitude, firstpos.longitude),
                PointLatLng(firstpos.latitude, firstpos.longitude),
                travelMode: TravelMode.walking,
              );
              print(
                  'ggggggggggggggggggggggggggggggggggggggggggggggggggggggg${result.errorMessage}');

              setState(() {});
              Geolocator.getPositionStream().listen((loc) async {
                Provider.of<CurrentPositionProvider>(context, listen: false)
                    .setPosition(
                        myPosition: MyPosition(
                            latitude: loc.latitude, longitube: loc.longitude));
              });
            },
          ),
      ],
    );
  }

  Future<void> _setmapStyle() async {
    final GoogleMapController controller = await _controller.future;
    controller.setMapStyle(_mapStyle);
    print('done');
  }

  // Future<void> _goToCurrentLocation() async {
  //   final loc = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   print('dddddddddddddddddddddd');
  //   print(loc);
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target: LatLng(6.6684279, -1.5745944),
  //           tilt: 59.440717697143555,
  //           zoom: 19.151926040649414),
  //     ),
  //   );
  // }
}

class CustomMarkers {
  // late BitmapDescriptor restaurantMarker;
  late BitmapDescriptor miscelineous;

  late BitmapDescriptor fillingStation;
  late BitmapDescriptor diner;
  late BitmapDescriptor gym;
  late BitmapDescriptor mobilemoney;
  late BitmapDescriptor mosque;
  late BitmapDescriptor policestation;
  late BitmapDescriptor repairs;
  late BitmapDescriptor school;
  late BitmapDescriptor shop;

  Future<void> initialize() async {
    // restaurantMarker = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size.fromHeight(100)),
    //     'assets/restaurant.png');

    miscelineous = await BitmapDescriptor.defaultMarker;
    fillingStation = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/fillingstation.png');
    diner = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/foodjoint.png');
    gym = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/gym.png');
    mobilemoney = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/mobilemoney.png');
    mosque = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/mosque.png');
    policestation = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/policestation.png');
    repairs = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/repairs.png');
    school = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/school.png');
    shop = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/shop.png');
  }

  BitmapDescriptor getMarker(String category) {
    switch (category) {
      case 'fillingStation':
        return fillingStation;
      case 'diner':
        return diner;
      case 'gym':
        return gym;
      case 'mobilemoney':
        return mobilemoney;
      case 'mosque':
        return mosque;
      case 'policestation':
        return policestation;
      case 'repairs':
        return repairs;
      case 'school':
        return school;
      case 'shop':
        return shop;
      default:
        return miscelineous;
    }
  }
}
