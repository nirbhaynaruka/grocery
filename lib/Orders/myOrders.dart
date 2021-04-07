import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "My Orders",
            style: TextStyle(
              letterSpacing: 1.3,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .document(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .orderBy(EcommerceApp.orderTime, descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (c, index) {
                        List<String> products = [];

                        snapshot
                            .data.documents[index].data[EcommerceApp.productID]
                            .forEach((k, v) => products.add(k));
                       
                        return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("items")
                              .where("productId", whereIn: products)
                              .getDocuments(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? OrderCard(
                                    itemCount: snap.data.documents.length,
                                    data: snap.data.documents,
                                    order: snapshot.data.documents[index]
                                        .data[EcommerceApp.productID],
                                    orderId: snapshot
                                        .data.documents[index].documentID,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        );
                      },
                   
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
