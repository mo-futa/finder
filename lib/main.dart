import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/providers/categoriesProvider.dart';
import 'package:finder_v2/providers/current_position_provider.dart';
import 'package:finder_v2/providers/generalState.dart';

import 'package:finder_v2/providers/userProvider.dart';
import 'package:finder_v2/screens/ListOfSpotMakers.dart';
import 'package:finder_v2/screens/LocationReviewScreen.dart';

import 'package:finder_v2/screens/MapScreen.dart';
import 'package:finder_v2/screens/UserProfileScreen.dart';
import 'package:finder_v2/screens/about_screen.dart';
import 'package:finder_v2/screens/adminScreen.dart';
import 'package:finder_v2/screens/becomeSpotMaker.dart';
import 'package:finder_v2/screens/loginScreen.dart';
import 'package:finder_v2/screens/make_spot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:finder_v2/models/user.dart' as mine;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CurrentPositionProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: CategoriesProvider()),
        ChangeNotifierProvider.value(value: GeneralState()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // primaryColor: mainColor,

            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => mainColor.withOpacity(0.3)),
            )),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => mainColor.withOpacity(0.3)),
                backgroundColor: MaterialStateProperty.all(mainColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    // side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            )
            // primarySwatch: Color('E88268'),
            ),
        home: 
        // AdminScreen(),
        const Root(),
        routes: {
          Root.root: (ctx) => const Root(),
          MapScreen.route: (ctx) => MapScreen(),
          UserProfileScreen.route: (ctx) => UserProfileScreen(),
          ListOfSpotMakers.route: (ctx) => const ListOfSpotMakers(),
          LoginScreen.route: (ctx) => LoginScreen(),
          BecomeSpotMaker.route: (ctx) => BecomeSpotMaker(),
          MakeSpotScreen.route: (ctx) => MakeSpotScreen(),
          AboutScreen.route: (ctx) => const AboutScreen(),
          LocationReviewScreen.route:(ctx)=>LocationReviewScreen(),
        },
      ),
    );
  }
} // class Test extends StatelessWidget {
//   final _textController = TextEditingController();
//   double? _rating = 3;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child:
//     ));
//   }
// }

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);
  static const String root = 'root';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      initialData: null,
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Text('loading'),
            ),
          );
        }
        if (snapshot.data == null) {
          return LoginScreen();
        }
        print('sssssssssssssssssssss${snapshot.data}');
        // return Scaffold(
        //   body: Center(
        //     child: ElevatedButton(
        //       child: Text(
        //         'Log out',
        //       ),
        //       onPressed: () => FirebaseAuth.instance.signOut(),
        //     ),
        //   ),
        // );
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, snapshott) {
            if (snapshott.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(
                  child: Text('loading'),
                ),
              );
            }
            Provider.of<UserProvider>(context).setUser(mine.User(
                id: snapshott.data!.id,
                imageUrl: snapshott.data!.data()!['imageUrl'],
                isSpotMaker: snapshott.data!.data()!['isSpotMaker'],
                name: snapshott.data!.data()!['name'],
                favorites: snapshott.data!.data()!['favorites']));

            return MapScreen();
          },
        );
      },
    );

    // final retrieved = Provider.of<User?>(context);
    // print('fffffffffffffffffffffffffffff$retrieved');
    // if (retrieved != null) {
    //   return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    //     future: FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(retrieved.uid)
    //         .get(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState != ConnectionState.done) {
    //         return LoginScreen();
    //       }
    //       Provider.of<UserProvider>(context, listen: false).setUser(mine.User(
    //           id: retrieved.uid,
    //           imageUrl: snapshot.data!.data()!['imageUrl'],
    //           name: snapshot.data!.data()!['name']));

    //       return MapScreen();
    //     },
    //   );
    // } else {
    //   return LoginScreen();
    // }
    // return retrieved == null ? LoginScreen() : MapScreen();
  }
}
