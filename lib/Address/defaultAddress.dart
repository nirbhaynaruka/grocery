import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/address.dart';
import 'package:grocery/Orders/placeOrderPayment.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Widgets/wideButton.dart';
import 'package:grocery/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class DefultAddress extends StatefulWidget {
  @override
  _DefultAddressState createState() => _DefultAddressState();
}

class _DefultAddressState extends State<DefultAddress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Address Page",
            style: TextStyle(
              letterSpacing: 1.3,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(Icons.shopping_basket, color: Colors.white),
                    onPressed: null,
                  ),
                ),
                Positioned(
                  top: 5.0,
                  right: 8.0,
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              (json
                                                .decode(EcommerceApp
                                                    .sharedPreferences
                                                    .getString(EcommerceApp
                                                        .userCartList))
                                                .length -
                                            1)
                                        .toString(),
                              style: TextStyle(
                                color: Color(0xff94b941),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        // MyAppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(
              builder: (context, address, c) {
                return Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.documents.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressID: snapshot
                                        .data.documents[index].documentID,
                                    // totalAmount: widget.totalAmount,
                                    model: AddressModel.fromJson(
                                        snapshot.data.documents[index].data),
                                  );
                                },
                              );
                  },
                ));
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => AddAddress(),
    transitionDuration: Duration(seconds: 0),
  ),);
          },
          label: Text("Add New Address"),
          backgroundColor: Color(0xff94b941),
          icon: Icon(
            Icons.add_location,
          ),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.greenAccent.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location,
              color: Colors.green,
            ),
            Text("No shipment address has been saved."),
            Text(
                "Please add your shipment Address so that we can deliver product."),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressID;
  // final double totalAmount;
  final int currentIndex;
  final int value;

  const AddressCard(
      {Key key,
      this.model,
      this.addressID,
      // this.totalAmount,
      this.currentIndex,
      this.value})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      // onLongPress: () {
      //   deleteaddress(widget.addressID);
      // },
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  activeColor: Color(0xff94b941),
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name"),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Phone Number"),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Flat Number / House Number"),
                              Text(widget.model.flatNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "City"),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "State"),
                              Text(widget.model.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Pincode"),
                              Text(widget.model.pincode),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            // widget.value == Provider.of<AddressChanger>(context).count
            //     ? WideButton(
            //         message: "Proceed",
            //         onPressed: () {
            //           Route route = MaterialPageRoute(
            //               builder: (c) => PaymentPage(
            //                     addressID: widget.addressID,
            //                     totalAmount: widget.totalAmount,
            //                   ));
            //           Navigator.push(context, route);
            //         },
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}

// deleteaddress(addressID) {
//   EcommerceApp.firestore
//       .collection("users")
//       .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .collection(EcommerceApp.subCollectionAddress)
//       .document(addressID)
//       .delete()
//       .then((value) => {
//             Fluttertoast.showToast(msg: EcommerceApp.subCollectionAddress),
//           });
// }

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
