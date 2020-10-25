import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:grocery/main.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  PaymentPage({
    Key key,
    this.addressId,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //  decoration: new BoxDecoration(
        //     gradient: new LinearGradient(
        //   colors: [Colors.pink, Colors.lightGreenAccent],
        //   begin: const FractionalOffset(0.0, 0.0),
        //   end: const FractionalOffset(1.0, 0.0),
        //   stops: [0.0, 1.0],
        //   tileMode: TileMode.clamp,
        // )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket_outlined,size: 100.0,color: Color(0xff94b941),),
            
            
            SizedBox(
                height: 30.0,
              ),
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
            ]

                ),
                child: FlatButton(
                  
                    onPressed: () => addOrderDetails(),
                    color: Colors.white,
                    textColor: Color(0xff94b941),
                    padding: EdgeInsets.all(8.0),
                    splashColor: Color(0xff94b941),
                    child: Text(
                      "place order",
                      style: TextStyle(fontSize: 30.0),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetalilsforUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash On delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });
    writeOrderDetalilsforAdmin({
      EcommerceApp.addressID: widget.addressId,
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
    });
    Fluttertoast.showToast(
        msg: "congrats, your order has been placed succesfully");

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
      ..collection(EcommerceApp.collectionOrders)
          .document(
              EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                  data['orderTime'])
          .setData(data);
  }
}
