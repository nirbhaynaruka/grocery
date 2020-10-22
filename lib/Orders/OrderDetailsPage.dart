import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Store/storehome.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Widgets/orderCard.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return SafeArea(
      child: Scaffold(),
    );
  }
}

class StatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
