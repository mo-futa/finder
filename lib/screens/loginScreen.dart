// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder_v2/constants.dart';
import 'package:finder_v2/main.dart';
import 'package:finder_v2/providers/userProvider.dart';
import 'package:finder_v2/screens/adminScreen.dart';
import 'package:finder_v2/widgets/profile_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MapScreen.dart';
import 'package:finder_v2/models/user.dart' as mine;

class LoginScreen extends StatefulWidget {
  static const String route = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _controller = PageController();
  bool isLong = true;
  bool loading = false;

  File? image;
  bool hasImage = true;
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  String? imageUrl, signupemail, name, signuppassword;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String? loginemail, loginPassword;

  Future<void> signUpFunction() async {
    if (!signupKey.currentState!.validate()) {
      print('ggggggggggggggggggggggggg');
      return;
    }
    if (image == null) {
      setState(() {
        hasImage = false;
      });
      return;
    }
    setState(() {
      loading = true;
    });
    if (image != null) {
      imageUrl = await uploadFile(context, image!);
    }
    signupKey.currentState!.save();
    UserCredential? result;

    try {
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signupemail!, password: signuppassword!);

      loading = false;
    } on FirebaseAuthException catch (e) {
      print(e.message);

      loading = false;

      throw e;
    }
    print('ffffffffffffffffffffffbefore');
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${result.user!.uid}')
        .set({
      'name': name,
      'email': signupemail,
      'imageUrl': imageUrl!,
      'isSpotMaker': false,
      'favorites': [],
    });

    print('ffffffffffffffffffffffafter');

    // Provider.of<UserProvider>(context, listen: false).setUser(mine.User(
    //   id: result.user!.uid,
    //   imageUrl: imageUrl!,
    //   name: name!,
    // ));
    // Navigator.of(context).popAndPushNamed(Root.root);
    // pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => Root()));
  }

  Future<void> signInFunction() async {
    if (!loginKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    loginKey.currentState!.save();
    UserCredential? result;
    //function to create firebase document and retieve id
    try {
      result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginemail!.trim(), password: loginPassword!);
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      setState(() {
        loading = false;
      });
      throw e;
    }
    // final usser = await FirebaseFirestore.instance.collection('users').
    // doc(result.user!.uid).get();
    // Provider.of<UserProvider>(context, listen: false).setUser(mine.User(
    //   id: result.user!.uid,
    //   imageUrl: usser.data()!['imageUrl'],
    //   name: usser.data()!['name'],
    // ));

    // Navigator.of(context).popAndPushNamed(Root.root);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(20),
              height: isLong ? 510 : 320,
              // shadowColor: Colors.white,
              child: PageView(
                // allowImplicitScrolling: false,
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  Form(
                    key: signupKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Welcome',
                              style: TextStyle(color: mainColor, fontSize: 30),
                            ),
                          ),
                          ProfilePicker((File file) {
                            image = file;
                            print('ddddddddddddddddddddd$image');
                          }),
                          if (!hasImage)
                            Text(
                              'please provide an image',
                              style: TextStyle(color: Colors.red),
                            ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null)
                                  return 'please provide a name';

                                return null;
                              },
                              onSaved: (newValue) {
                                name = newValue;
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null)
                                  return 'please provide an email';
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                signupemail = newValue!.trim();
                              },
                              decoration: InputDecoration(
                                hintText: 'email',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'password required';
                                }
                                if (value.length < 8) {
                                  return 'password must be 8 letters long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                signuppassword = newValue!.trim();
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await signUpFunction();
                              },
                              child: Text('Sign Up')),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              _controller.animateToPage(1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              setState(() => isLong = false);
                            },
                            child: Text(
                              'Already have an account',
                              style: TextStyle(color: mainColor),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: loginKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Welcome back',
                              style: TextStyle(color: mainColor, fontSize: 30),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'email required';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                loginemail = newValue;
                              },
                              decoration: InputDecoration(
                                hintText: 'email',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'password required';
                                }
                                if (value.length < 8) {
                                  return 'password must be 8 letters long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                loginPassword = newValue;
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await signInFunction();
                              },
                              child: Text('Log in')),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              _controller.animateToPage(0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              setState(() => isLong = true);
                            },
                            child: Text(
                              "Don't have an Account?",
                              style: TextStyle(color: mainColor),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => AdminScreen(),
                    ),
                  );
                },
                child: Text('Admin')),
          ),
          if (loading)
            AbsorbPointer(
              absorbing: true,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.grey.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
