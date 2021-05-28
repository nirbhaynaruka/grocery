import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminOrderCard.dart';
import 'package:grocery/Config/config.dart';
import 'package:flutter/material.dart';
import '../Widgets/loadingWidget.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  List<String> products = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          centerTitle: true,
          title: Text(
            "Pending Orders",
            style: TextStyle(
              fontSize: 25.0,
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.arrow_drop_down_circle),
                color: Colors.white,
                onPressed: () {
                  // SystemNavigator.pop();
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index) {
                      products.clear();
                      snapshot
                          .data.documents[index].data[EcommerceApp.productID]
                          .forEach((k, v) => products.add(k));
                      print(products);
                      return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("items")
                            .where("productId", whereIn: products)
                            .getDocuments(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? snapshot.data.documents[index]
                                          .data["orderDetails"] !=
                                      "Delivered"
                                  ? AdminOrderCard(
                                      itemCount: snap.data.documents.length,
                                      data: snap.data.documents,
                                      order: snapshot.data.documents[index]
                                          .data[EcommerceApp.productID],
                                      orderID: snapshot
                                          .data.documents[index].documentID,
                                      orderBy: snapshot.data.documents[index]
                                          .data["orderBy"],
                                      addressID: snapshot.data.documents[index]
                                          .data["addressID"],
                                    )
                                  : Container()
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text("no orders"),
                  );
          },
        ),
      ),
    );
  }
}
