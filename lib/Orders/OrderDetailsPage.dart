import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Widgets/orderCard.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
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
                              "Order Time: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(height: 2.0),
                          FutureBuilder<QuerySnapshot>(
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                      orderId: orderId,
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
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 15,
            color: Color(0xFFB7B7B7).withOpacity(.5),
          ),
        ],
      ),
      height: 70.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20.0),
              Text(
                "Order Placed " + msg,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontFamily: "Arial Bold"),
              ),
              SizedBox(width: 5.0),
              CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.white70,
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.green,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            child: Center(
              child: Text(
                "Order " + msg1,
                style: TextStyle(
                  fontFamily: "Arial Bold",
                  fontSize: 15,
                ),
              ),
            ),
          ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details:",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "Arial Bold",
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 15,
                color: Color(0xFFB7B7B7).withOpacity(.5),
              ),
            ],
          ),
          width: screenWidth,
          child: Table(
            border: TableBorder.all(width: 1.0),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.name),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "Phone Number"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.phoneNumber),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "Flat Number/ Street Number/ House Number"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.flatNumber),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "City"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.city),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "State"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.state),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KeyText(msg: "Pincode"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(model.pincode),
                  ),
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
