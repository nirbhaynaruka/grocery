import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Widgets/orderCard.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/main.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  @override
  final String orderId;
  OrderDetails({
    Key key,
    this.orderId,
  }) : super(key: key);

  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                            status1: dataMap[EcommerceApp.orderDetails],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              '\u{20B9}${dataMap[EcommerceApp.totalAmount].toString()}',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("OrderId: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "order at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID])
                                .get(),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderId)
                .get(),
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;
  final String status1;
  StatusBanner({Key key, this.status, this.status1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    String msg1;
    IconData iconData;
    status1 != null ? msg1 = status1 : msg1 = "Waiting For Confirmation";
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "unSuccesffull";
    // status1 ? msg1 = "okok1" : msg1 = "ok";
    return Container(
      height: 40.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
              ),
              Text(
                "order placed " + msg,
                style: TextStyle(color: Colors.green),
              ),
              SizedBox(
                width: 5.0,
              ),
              CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.white70,
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.green,
                    size: 14.0,
                  ),
                ),
              ),
            ],
          ),
          Container(child: Center(child: Text("Order " + msg1))),
        ],
      ),
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  ShippingDetails({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(msg: "Name"),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Phone Number"),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Flat Number / House Number"),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "City"),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "State"),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Pincode"),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50.0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  confirmedOrderRec(context, getOrderId);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff94b941),
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  width: MediaQuery.of(context).size.width - 40.0,
                  child: Center(
                    child: Text(
                      "confirmed || Item Received",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmedOrderRec(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({
      "orderDetails": "Delivered",
    });

    getOrderId = "";
    // Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => SplashScreen(),
    //     transitionDuration: Duration(seconds: 0),
    //   ),
    // );
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Order has been Received. Confirmed.");
  }
}
