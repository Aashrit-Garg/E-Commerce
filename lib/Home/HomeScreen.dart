import 'package:ecommerce/Components/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

import '../enums.dart';
import '../size_config.dart';
import 'DiscountBanner.dart';
import 'HomeHeader.dart';
import 'PopularProducts.dart';
import 'SpecialOffers.dart';
import 'categories.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: getProportionateScreenWidth(30)),
              PopularProducts(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
