import 'package:flutter/material.dart';

import 'Details/DetailsScreen.dart';
import 'Home/HomeScreen.dart';
import 'SignIn/SignInScreen.dart';
import 'SignUp/SignUpScreen.dart';
import 'Welcome/SplashScreen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  // ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  // CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  // OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  // CartScreen.routeName: (context) => CartScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
