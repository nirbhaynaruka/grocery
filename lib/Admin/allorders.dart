import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminOrderCard.dart';
import 'package:grocery/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';

class Allorders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<Allorders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          centerTitle: true,
          title: Text(
            "Delivered Orders",
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
            return
             snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("items")
                            .where("shortInfo",
                                whereIn: snapshot.data.documents[index]
                                    .data[EcommerceApp.productID])
                            .getDocuments(),
                        builder: (c, snap) {
                          return 
                          snap.hasData
                              ? snapshot.data.documents[index].data["orderDetails"] == "Delivered" ? AdminOrderCard(
                                  itemCount: snap.data.documents.length,
                                  data: snap.data.documents,
                                  orderID:
                                      snapshot.data.documents[index].documentID,
                                  orderBy: snapshot.data.documents[index].data["orderBy"],
                                  addressID: snapshot.data.documents[index].data["addressID"],
                                ) : Container()
                              : 
                              Center(
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
