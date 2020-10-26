import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Store/product_page.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:grocery/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/loadingWidget.dart';
import '../Models/item.dart';

double width;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(Category());
}

class Category extends StatefulWidget {
  // final ItemModel itemModel;
  final String catname;
  Category({this.catname});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool logincheck = false;
  @override
  void initState() {
    checklogin();
    super.initState();
  }

  checklogin() async {
    if (await EcommerceApp.auth.currentUser() != null) {
      setState(() {
        logincheck = true;
      });
    } else {
      setState(() {
        logincheck = false;
      });
    }
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            widget.catname,
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
                      onPressed: () {
                        checklogin();
                        if (logincheck) {
                          Route route =
                              MaterialPageRoute(builder: (c) => CartPage());
                          Navigator.push(context, route);
                        } else {
                          Route route = MaterialPageRoute(
                              builder: (_) => AuthenticScreen());
                          Navigator.push(context, route);
                        }
                      }),
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
                              logincheck
                                  ? (EcommerceApp.sharedPreferences
                                              .getStringList(
                                                  EcommerceApp.userCartList)
                                              .length -
                                          1)
                                      .toString()
                                  : "0",
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
        floatingActionButton: Transform.scale(
          scale: 1.1,
          child: FloatingActionButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SearchProduct());
              Navigator.push(context, route);
            },
            elevation: 5,
            backgroundColor: Color(0xff94b941),
            splashColor: Color(0xffdde8bd),
            child: Icon(Icons.search, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            // SliverPersistentHeader(
            //   delegate: SearchBoxDelegate(),
            //   pinned: true,
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(widget.catname)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.documents[index].data);

                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.documents.length);
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  Size size;
  // heightm = MediaQuery.of(context).size.height;
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Color(0xff94b941),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 5,
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
                    height: MediaQuery.of(context).size.height / 5,
                    child: Image.network(
                      model.thumbnailUrl,
                      width: MediaQuery.of(context).size.width * 0.33,
                      // height: 140.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.0,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                // Icon(Icons.curr),

                                Text(
                                  '\u{20B9}${model.price}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '\u{20B9}${model.originalPrice}',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          removeCartFunction == null
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        checkItemInCart(
                                            model.shortInfo, context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff94b941),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        //  color: Colors.green,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        height: 50.0,
                                        child: Center(
                                          child: Text(
                                            "Add",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              // IconButton(
                              //     icon: Icon(
                              //       Icons.add_shopping_cart,
                              //       color: Colors.pinkAccent,
                              //     ),
                              //     onPressed: () {
                              //       checkItemInCart(model.shortInfo, context);
                              //     })
                              : IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Color(0xff94b941),
                                  ),
                                  onPressed: () {
                                    removeCartFunction();
                                  }),
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
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * 0.34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Image.network(
          imgPath,
          height: 150.0,
          width: width * 0.34,
          fit: BoxFit.fill,
        )),
  );
}

void checkItemInCart(String productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(productID)
      ? Fluttertoast.showToast(msg: "Item is Already in the Cart!")
      : addItemToCart(productID, context);
}

addItemToCart(String productID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(productID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
    EcommerceApp.userCartList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
