import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminOrderCard.dart';
import 'package:grocery/Orders/OrderDetailsPage.dart';
import 'package:grocery/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderId;

  OrderCard({
    Key key,
    this.itemCount,
    this.data,
    this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route =
              MaterialPageRoute(builder: (c) => OrderDetails(orderId: orderId));
        }
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceInfo(model, context);
          },
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background}) {
  width = MediaQuery.of(context).size.width;

  return Column(
    children: [
      // Text("data"),
      Container(
        color: Colors.green[100],
        height: 170.0,
            width: width,
            child: Row(
              children: [
                // Image.network(
                //   model.thumbnailUrl,
                //   width: 180.0,
                // ),
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
                      ]
                        ),
                height:MediaQuery.of(context).size.height / 5,

                        child: Image.network(
                          model.thumbnailUrl,
                          width: MediaQuery.of(context).size.width * 0.33,
                          // height: 140.0,
                        ),
                      ),
                    ),
                SizedBox(
                  width: 10.0,
                ),
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
                                      fontSize: 25.0,
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
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                         
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                     Text(
                                  '\u{20B9}${model.price}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                     Text(
                                      '\u{20B9}${(model.price + model.price*0.25).toString()}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                      Divider(height: 5.0, color: Colors.black),
    ],
  );
}
