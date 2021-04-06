import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Widgets/sourceInfo.dart';
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
    setState(() {});
    totalAmmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayResult(0);
  }

  @override
  Widget build(BuildContext context) {
    List<String> products = [];

    json
        .decode(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList))
        .forEach((k, v) => products.add(k));
    print(products);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if ((json.decode(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userCartList)))
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your Cart is Empty!!");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmmount));
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => Address(totalAmount: totalAmmount),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          }
        },
        label: Text("Check Out"),
        backgroundColor: Color(0xff94b941),
        icon: Icon(Icons.navigate_next),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff94b941),
        title: Text(
          "Cart Page",
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
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
                            (json
                                        .decode(EcommerceApp.sharedPreferences
                                            .getString(
                                                EcommerceApp.userCartList))
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
                  // child: cartProvider.count == 0
                  // ?
                  // Container()
                  // :
                  child: Text(
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
                .where("productId", whereIn: products)
                // .orderBy("productId")
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
                              int quan = json.decode(EcommerceApp
                                      .sharedPreferences
                                      .getString(EcommerceApp.userCartList))[
                                  model.productId];
                              // print(model.productId.toString());
                              if (index == 0) {
                                totalAmmount = 0;
                                totalAmmount =
                                    model.price * quan + totalAmmount;
                              } else {
                                totalAmmount =
                                    model.price * quan + totalAmmount;
                              }

                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayResult(totalAmmount);
                                });
                              }
                              return SourceInfo(
                                  model: model,
                                  quantity: quan,
                                  totalAmount: totalAmmount,
                                  addQuantityFunction: () =>
                                      addItemQuantityToCart(model.productId,
                                          quan, model.newPrice),
                                  removeCartFunction: () =>
                                      removeItemFromUserCart(model.productId));
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
              Text("Start Shopping..."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsID) {
    String tempCartList =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList);
    Map<String, dynamic> decodedMap = json.decode(tempCartList);
    decodedMap.removeWhere((key, value) => key == shortInfoAsID);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: decodedMap,
    }).then((v) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Item Removed Successfully. Continue Shopping");

      EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userCartList, json.encode(decodedMap));
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      setState(() {
        totalAmmount = 0;
      });
    });
  }

  addItemQuantityToCart(String shortInfoAsID, int quantity, int price) {
    String tempCartList =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList);
    Map<String, dynamic> decodedMap = json.decode(tempCartList);

    decodedMap.update(shortInfoAsID, (value) => quantity);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: decodedMap,
    }).then((v) {
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: "Item Quantity Changed Successfull");

      EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userCartList, json.encode(decodedMap));
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      setState(() {
        totalAmmount = totalAmmount + (price * quantity);
      });
    });
  }
}
