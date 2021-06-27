import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Components/NoAccountText.dart';
import 'package:ecommerce/Components/SocialCard.dart';
import 'package:ecommerce/Home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../size_config.dart';
import 'SignForm.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User currentUser;
  bool showSpinner;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () async {
                          try {
                            setState(() {
                              showSpinner = true;
                            });
                            final user = await signInWithGoogle();
                            var documentReference = FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.user.uid);
                            _firestore.runTransaction((transaction) async {
                              transaction.set(
                                documentReference,
                                {
                                  'email': user.user.email,
                                },
                              );
                            });
                            if (user != null) {
                              setState(() {
                                showSpinner = false;
                              });
                              // Navigate to Home
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                              showOkAlertDialog(
                                  context: context,
                                  title: "Login Success!",
                                  message:
                                      "Google Authentication was successful.");
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            showOkAlertDialog(
                                context: context,
                                title: "Login Failed",
                                message:
                                    "Google Authentication Failed. Check your internet and try again!");
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
