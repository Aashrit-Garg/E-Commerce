import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Components/DefaultButton.dart';
import 'package:ecommerce/Model/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../size_config.dart';
import 'ColorDots.dart';
import 'ProductDescription.dart';
import 'ProductImages.dart';
import 'TopRoundedContainer.dart';

class Body extends StatefulWidget {
  final Product product;

  const Body({Key key, @required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _firestore = FirebaseFirestore.instance;
  Razorpay _razorpay;
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    ColorDots(product: widget.product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Buy Now",
                          press: () async {
                            currentUser = await _auth.currentUser;
                            var options = {
                              'key': 'rzp_test_GU4sxMwGXhWBac',
                              'amount':
                                  (widget.product.price * 74.22 * 100).toInt(),
                              'name': 'E-Commerce',
                              'description': 'Order received for 1 item',
                              'prefill': {'email': currentUser.email},
                              'external': {
                                'wallets': ['paytm']
                              }
                            };

                            try {
                              setState(() {
                                showSpinner = true;
                              });
                              _razorpay.open(options);
                            } catch (e) {
                              debugPrint(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Orders')
        .add({
      'paymentID': response.paymentId,
      'name': widget.product.title,
      'price': widget.product.price,
      'date': [DateTime.now().day, DateTime.now().month, DateTime.now().year],
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Order Successfully Received",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "Order Failed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    setState(() {
      showSpinner = false;
    });
    if (response.code != 2) {
      Fluttertoast.showToast(msg: "ERROR: " + response.code.toString());
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      showSpinner = false;
    });
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }
}
