import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Orders/OrderDetailsPage.dart';
import 'package:grocery/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

class OrderCard extends StatefulWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final Map<String, dynamic> order;
  final String orderId;

  OrderCard({
    Key key,
    this.itemCount,
    this.data,
    this.orderId,
    this.order,
  }) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => OrderDetails(orderId: widget.orderId));
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        // margin: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(5),
        // padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 15,
                color: Color(0xFFB7B7B7).withOpacity(.5),
              ),
            ],
            border: Border.all(color: Colors.black, width: 2.0)),
        height: widget.itemCount * 140.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(widget.data[index].data);
            int quantity = widget.order[model.productId];
            return sourceorderInfo(model, context, quantity: quantity);
          },
          itemCount: widget.itemCount,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

Widget sourceorderInfo(ItemModel model, BuildContext context,
    {Color background, int quantity}) {
  width = MediaQuery.of(context).size.width;

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Color(0xff94b941).withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 15,
              color: Color(0xFFB7B7B7).withOpacity(.5),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 130.0,
        width: width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                height: MediaQuery.of(context).size.height / 7,
                child: CachedNetworkImage(
                  imageUrl: model.thumbnailUrl,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: MediaQuery.of(context).size.width * 0.33,
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Arial Bold",
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Arial",
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  '\u{20B9}${model.price * quantity}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arial Bold",
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '\u{20B9}${model.originalPrice * quantity}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Arial Bold",
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Qty - $quantity',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Arial Bold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Divider(height: 5.0, color: Colors.black),
    ],
  );
}
