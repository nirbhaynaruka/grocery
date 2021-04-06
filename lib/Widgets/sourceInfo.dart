import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Counters/totalMoney.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Store/category.dart';
import 'package:grocery/Store/product_page.dart';
import 'package:provider/provider.dart';

class SourceInfo extends StatefulWidget {
  final ItemModel model;
  final int quantity;
  final double totalAmount;
  final Function removeCartFunction;
  final Function addQuantityFunction;
  const SourceInfo(
      {Key key,
      this.model,
      this.removeCartFunction,
      this.quantity,
      this.addQuantityFunction,
      this.totalAmount})
      : super(key: key);

  @override
  _SourceInfoState createState() => _SourceInfoState();
}

class _SourceInfoState extends State<SourceInfo> {
  List<int> _quantity = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int _quantityCounter;
  double totalAmount;

  @override
  void initState() {
    _quantityCounter = widget.quantity;
    totalAmount = widget.totalAmount;
    // totalAmount = Provider.of<TotalAmount>(context, listen: false).totalAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductPage(itemModel: widget.model));
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductPage(itemModel: widget.model),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      },
      splashColor: Color(0xff94b941),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Container(
                // color: Color(0xffffffff),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 15,
                      color: Color(0xFFB7B7B7).withOpacity(.5),
                    ),
                  ],
                ),
                // height: MediaQuery.of(context).size.height / 6,
                width: width,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        height: MediaQuery.of(context).size.height / 7,
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.33,
                          imageUrl: widget.model.thumbnailUrl,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.0),
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.model.title,
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
                                      widget.model.shortInfo,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Arial",
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\u{20B9}${widget.model.price * _quantityCounter}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        '\u{20B9}${widget.model.originalPrice * _quantityCounter}',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.removeCartFunction == null
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              checkItemInCart(
                                                  widget.model.productId,
                                                  1,
                                                  context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xff94b941),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6))),
                                              //  color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: 30.0,
                                              child: Center(
                                                child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 0.0),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0.0,
                                                  vertical: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(0, 4),
                                                    blurRadius: 15,
                                                    color: Color(0xFFB7B7B7)
                                                        .withOpacity(.5),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Qty: ",
                                                    style: TextStyle(
                                                      fontFamily: "Arial Bold",
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  DropdownButton(
                                                    style: TextStyle(
                                                      fontFamily: "Arial Bold",
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                    underline: Container(),
                                                    isExpanded: false,
                                                    value: _quantityCounter,
                                                    items: _quantity.map((val) {
                                                      return DropdownMenuItem(
                                                        child: Text(
                                                            val.toString()),
                                                        value: val,
                                                      );
                                                    }).toList(),
                                                    onChanged: (val) async {
                                                      this.setState(() {
                                                        _quantityCounter = val;
                                                      });

                                                      addItemToCart(
                                                              widget.model
                                                                  .productId,
                                                              _quantityCounter,
                                                              context)
                                                          .then((value) => this
                                                              .setState(() {}));

                                                      this.setState(() {
                                                        totalAmount = (widget
                                                                    .model
                                                                    .price *
                                                                _quantityCounter) +
                                                            totalAmount;
                                                      });
                                                      print(totalAmount);

                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        Provider.of<TotalAmount>(
                                                                context,
                                                                listen: false)
                                                            .displayResult(
                                                                totalAmount);
                                                      });

                                                      setState(() {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder:
                                                                (_, __, ___) =>
                                                                    CartPage(),
                                                            transitionDuration:
                                                                Duration(
                                                                    seconds: 0),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Color(0xff94b941),
                                                ),
                                                onPressed: () {
                                                  widget.removeCartFunction();
                                                }),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
