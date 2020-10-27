import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Admin/uploadItems.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Orders/myOrders.dart';
import 'package:grocery/Store/category.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Widgets/orderCard.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({
    Key key,
    this.orderID,
    this.orderBy,
    this.addressID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;

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
                          AdminStatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                            status1: dataMap[EcommerceApp.orderDetails],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "rs." +
                                  dataMap[EcommerceApp.totalAmount].toString(),
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
                                  ? AdminShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                      orderBy: orderBy)
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(orderBy)
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(addressID)
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
                .collection(EcommerceApp.collectionOrders)
                // .document(EcommerceApp.sharedPreferences
                //     .getString(EcommerceApp.userUID))
                // .collection(EcommerceApp.collectionOrders)
                .document(getOrderId)
                .get(),
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;
  final String status1;
  AdminStatusBanner({Key key, this.status, this.status1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    String msg1;
    IconData iconData;
    status1 != null ? msg1 = status1 : msg1 = "Waiting For Confirmation";

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successfully" : msg = "unSuccesful";

    return Column(
      children: [
        Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
              ),
              Text(
                "Order Shipped " + msg,
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
              )
            ],
          ),
        ),
        Container(
          color: Color(0xff94b941),
          child: Center(
            child: Text(msg1),
          ),
        )
      ],
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;
  final orderBy;
  AdminShippingDetails({Key key, this.model, this.orderBy}) : super(key: key);
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
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      outofstock(context, getOrderId);
                      Navigator.pop(context);

                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff94b941),
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      width: MediaQuery.of(context).size.width - 40.0,
                      child: Center(
                        child: Text(
                          "OUT OF STOCK",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      confirmedparcelshift(context, getOrderId);
                      Navigator.pop(context);

                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff94b941),
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      width: MediaQuery.of(context).size.width - 40.0,
                      child: Center(
                        child: Text(
                          "Parcel Shifted",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      confirmedparceldelivered(context, getOrderId);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff94b941),
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      width: MediaQuery.of(context).size.width - 40.0,
                      child: Center(
                        child: Text(
                          "Parcel Delivered",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  outofstock(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({"orderDetails": "Out of Stock"});
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(orderBy)
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({
      "orderDetails": "Out of Stock",
    });
    getOrderId = "";
  }

  confirmedparceldelivered(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({"orderDetails": "Delivered"});
    print(mOrderId);
    // print(mOrderId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(orderBy)
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({
      "orderDetails": "Delivered",
    });
  }

  confirmedparcelshift(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({"orderDetails": "order processed"});
    print(mOrderId);
    // print(mOrderId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(orderBy)
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .updateData({
      "orderDetails": "order processed",
    });

    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Parcel has been Shifted. Confirmed.");
  }
}
