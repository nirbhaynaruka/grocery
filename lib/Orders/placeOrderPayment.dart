import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/main.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressID;
  final double totalAmount;
  PaymentPage({
    Key key,
    this.addressID,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _controller = TextEditingController();
  Widget button = Container();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Place Order",
            style: TextStyle(
              fontSize: 25.0,
              letterSpacing: 1.5,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child: Padding(
                //     padding: EdgeInsets.all(15.0),
                //     child: Text(
                //       "Apply Coupon Code",
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20.0,
                //       ),
                //     ),
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.all(20.0),
                //   color: Colors.amber,
                //   child: GestureDetector(
                //     // onTap: () {
                //     //   setState(() {
                //     //     button = RaisedButton(
                //     //       onPressed: () {},
                //     //       color: Color(0xff94b941),
                //     //       child: Text(
                //     //         "Apply",
                //     //         style: TextStyle(color: Colors.black),
                //     //       ),
                //     //     );
                //     //   });
                //     // },
                //     child: TextField(
                //       controller: _controller,
                //       decoration: InputDecoration.collapsed(
                //           hintText: "Type Coupon Code"),
                //     ),
                //   ),
                // ),
                // RaisedButton(
                //   onPressed: () {},
                //   color: Color(0xff94b941),
                //   child: Text(
                //     "Apply",
                //     style: TextStyle(color: Colors.black),
                //   ),
                // ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      child: Text(
                        "Order Summary",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  // width: screenWidth * 1,
                  child: Table(
                    border: TableBorder.all(width: 1.0),
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Order Address: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.addressID),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Order Items: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString()),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Sub Total: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Rs. " + widget.totalAmount.toString()),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Shipping(including GST):"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Rs. 0"),
                          ),
                        ],
                      ),
                      // TableRow(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: KeyText(msg: "Coupon Code(applied):"),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(widget.addressID),
                      //     ),
                      //   ],
                      // ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Total"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("Rs. " + (widget.totalAmount.toString())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 100.0,
                  color: Color(0xff94b941),
                ),
                SizedBox(height: 30.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: FlatButton(
                      onPressed: () => addOrderDetails(),
                      color: Colors.white,
                      textColor: Color(0xff94b941),
                      padding: EdgeInsets.all(8.0),
                      splashColor: Color(0xff94b941),
                      child: Text(
                        "Place Order",
                        style: TextStyle(fontSize: 30.0),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetalilsforUser({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash On delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });
    writeOrderDetalilsforAdmin({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash On delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {emptyCartNow()});
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(
        msg: "Congrats, Your Order has been Placed Succesfully");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future writeOrderDetalilsforUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }

  Future writeOrderDetalilsforAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }
}
