import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminOrderDetails.dart';
import 'package:grocery/Models/item.dart';
import 'package:flutter/material.dart';

import '../Store/storehome.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  const AdminOrderCard({Key key, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell();
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background}) {
  return Container();
}
