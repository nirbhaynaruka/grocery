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
  final Map<String, dynamic> order;

  const AdminOrderCard(
      {Key key,
      this.itemCount,
      this.data,
      this.orderID,
      this.addressID,
      this.orderBy,
      this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => AdminOrderDetails(
                orderID: orderID, orderBy: orderBy, addressID: addressID));
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(5.0),
         decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 15,
                color: Color(0xFFB7B7B7).withOpacity(.5),
              ),
            ],
            border: Border.all(color: Color(0xff94b941), width: 2.0)),
        height: itemCount * 150.0,
        child: ListView.builder(
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            int quantity = order[model.productId];
            return sourceorderInfo(model, context, quantity: quantity);
          },
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
