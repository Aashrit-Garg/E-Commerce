import 'package:ecommerce/Model/Product.dart';
import 'package:flutter/material.dart';

import 'Body.dart';
import 'CustomAppBar.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";
  final Product product;

  DetailsScreen({this.product});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: widget.product.rating),
      body: Body(product: widget.product),
    );
  }
}
