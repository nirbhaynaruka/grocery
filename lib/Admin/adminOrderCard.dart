import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminOrderDetails.dart';
import 'package:grocery/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Widgets/orderCard.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  const AdminOrderCard(
      {Key key,
      this.itemCount,
      this.data,
      this.orderID,
      this.addressID,
      this.orderBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  Route route =
        //                   MaterialPageRoute(builder: (c) => CartPage());
        //               Navigator.push(context, route);
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(
              builder: (c) => AdminOrderDetails(
                  orderID: orderID, orderBy: orderBy, addressID: addressID));
          Navigator.push(context, route);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return 
            // Text("data");
            sourceorderInfo(model, context);
          },
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
