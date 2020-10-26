import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Store/product_page.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Store/category.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmmount;
  @override
  void initState() {
    super.initState();
    totalAmmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayResult(0);
  }

  int _itemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your Cart is Empty!!");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmmount));
            Navigator.push(context, route);
          }
        },
        label: Text("Check Out"),
        backgroundColor: Color(0xff94b941),
        icon: Icon(Icons.navigate_next),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff94b941),
        title: Text(
          "Nature Coop Fresh",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Folks-Heavy",
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: Icon(Icons.shopping_basket, color: Colors.white),
                  onPressed: null,
                ),
              ),
              Positioned(
                top: 5.0,
                right: 8.0,
                child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 6.0,
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                          return Text(
                            (EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString(),
                            style: TextStyle(
                              color: Color(0xff94b941),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),

      // drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total Price: Rs ${amountProvider.totalAmount.toString()}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);

                              // model.price = model.price * 2;

                              if (index == 0) {
                                totalAmmount = 0;
                                totalAmmount = model.price + totalAmmount;
                              } else {
                                totalAmmount = model.price + totalAmmount;
                              }

                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayResult(totalAmmount);
                                });
                              }
                              return InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (c) =>
                                          ProductPage(itemModel: model));
                                  Navigator.push(context, route);
                                },
                                splashColor: Color(0xff94b941),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          width: width,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(0,
                                                              3), // changes position of shadow
                                                        ),
                                                      ]),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                  child: Image.network(
                                                    model.thumbnailUrl,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.33,
                                                    // height: 140.0,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              model.title,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Arial Bold",
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
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              model.shortInfo,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontFamily:
                                                                    "Arial",
                                                                fontSize: 20.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 20.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.0),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Icons.curr),

                                                              Text(
                                                                '\u{20B9}${model.price * _itemCount}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                              Text(
                                                                '\u{20B9}${model.originalPrice * _itemCount}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .grey,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                       Row(
                                                                children: [
                                                                  _itemCount !=
                                                                          1
                                                                      ? IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                Color(0xff94b941),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                                setState(() {
                                                                                  
                                                                            _itemCount--;
                                                                                });
                                                                          }
                                                                          //  => setState(()=>_itemCount--),
                                                                          )
                                                                      : new Container(),
                                                                  Text(_itemCount
                                                                      .toString()),
                                                                  IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Color(
                                                                            0xff94b941),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                            setState(() {
                                                                              
                                                                        _itemCount++;
                                                                            });
                                                                      }
                                                                      // =>setState(()=>_itemCount++))
                                                                      ),
                                                                  IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Color(
                                                                            0xff94b941),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        removeItemFromUserCart(model.shortInfo);
                                                                      }),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                    // Divider(height: 5.0, color: Colors.black),

                                                    // Flexible(
                                                    //   child: Container(),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(height: 5.0, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              );
                              // sourceInfo(model, context,
                              //     removeCartFunction: () =>
                              //         removeItemFromUserCart(model.shortInfo));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          )
        ],
      ),
    );
  }

  beginbuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.black,
              ),
              Text("Cart is Empty!!"),
              Text("Starting Shopping..."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsID) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsID);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item Removed Successfully.");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      // setState(() {
      setState(() {
        totalAmmount = 0;
      });
      // });
    });
  }
}
