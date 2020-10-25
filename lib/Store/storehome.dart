import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Store/category.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery/Widgets/customSlider.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grocery/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(StoreHome());
}

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  bool logincheck = false;
  Size size;

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

  List<ItemModel> model = [
    ItemModel(
      catname: "Fruits & Vegetables",
      catthumbnail: "assets/images/FruitsandVegetables.png",
    ),
    ItemModel(
      catname: "Dairy Products",
      catthumbnail: "assets/images/DairyProducts.png",
    ),
    ItemModel(
      catname: "Cleaning & Household",
      catthumbnail: "assets/images/Cleaning_Household.png",
    ),
    ItemModel(
      catname: "Beauty & Hygeine",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
    ItemModel(
      catname: "Beverages and Snacks",
      catthumbnail: "assets/images/Beverage_Snacks.png",
    ),
    ItemModel(
      catname: "Cooking Essentials",
      catthumbnail: "assets/images/CookingEssentials.png",
    ),
    ItemModel(
      catname: "Miscellaneous",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
    ItemModel(
      catname: "Packaged Foods",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
  ];
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                IconButton(
                    icon: Icon(Icons.shopping_basket, color: Colors.white),
                    onPressed: () {
                      // checklogin();
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
                Positioned(
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CarouselPage(),
              ),
              SizedBox(height: 35),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "SHOP BY CATEGORY",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Arial Bold",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(10.0),
                    childAspectRatio: 0.9,
                    children: model.map((model) {
                      return categoryinfo(model, context);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
        floatingActionButton: Transform.scale(
          scale: 1.2,
          child: FloatingActionButton(
            onPressed: () => SearchBoxDelegate(),
            elevation: 5,
            backgroundColor: Color(0xff94b941),
            splashColor: Color(0xffdde8bd),
            child: Icon(Icons.search, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Widget categoryinfo(ItemModel model, BuildContext context,
    {Color: Colors.white}) {
  return GestureDetector(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => Category(itemModel: model));
      Navigator.push(context, route);
    },
    child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              model.catthumbnail,
              fit: BoxFit.cover,
              height: 80.0,
            ),
            SizedBox(height: 30.0),
            Text(
              model.catname,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Arial Bold",
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
        //     InkWell(

        //     child: Text(model.catname),
        // ),
        ),
  );
}
// Widget categoryinfo(ItemModel model, BuildContext context){
//   return GestureDetector{
//     onTap:(){
//        Route route =
//                             MaterialPageRoute(builder: (c) => Category(itemModel: model));
//                         Navigator.push(context, route);
//     },
//     child: Text("model");
//   };

//   }

// Widget sourceInfo(ItemModel model, BuildContext context,
//     {Color background, removeCartFunction}) {
//   return InkWell(
//     onTap: () {
//       Route route =
//           MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
//       Navigator.push(context, route);
//     },
//     splashColor: Colors.pink,
//     child: Padding(
//       padding: EdgeInsets.all(6.0),
//       child: Container(
//         height: 190.0,
//         width: width,
//         child: Row(
//           children: [
//             Image.network(
//               model.thumbnailUrl,
//               width: 140.0,
//               height: 140.0,
//             ),
//             SizedBox(
//               width: 4.0,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             model.title,
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5.0),
//                   Container(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             model.shortInfo,
//                             style: TextStyle(
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           color: Colors.pink,
//                         ),
//                         alignment: Alignment.topLeft,
//                         width: 40.0,
//                         height: 43.0,
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "50%",
//                                 style: TextStyle(
//                                   fontSize: 15.0,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                               Text(
//                                 "OFF",
//                                 style: TextStyle(
//                                   fontSize: 12.0,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 0.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   r"Original Price: $",
//                                   style: TextStyle(
//                                     fontSize: 14.0,
//                                     color: Colors.grey,
//                                     decoration: TextDecoration.lineThrough,
//                                   ),
//                                 ),
//                                 Text(
//                                   (model.price + model.price).toString(),
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.grey,
//                                     decoration: TextDecoration.lineThrough,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 5.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   r"New Price: ",
//                                   style: TextStyle(
//                                     fontSize: 14.0,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 Text(
//                                   r"$",
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                                 Text(
//                                   (model.price).toString(),
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Flexible(
//                     child: Container(),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: removeCartFunction == null
//                         ? IconButton(
//                             icon: Icon(
//                               Icons.add_shopping_cart,
//                               color: Colors.pinkAccent,
//                             ),
//                             onPressed: () {
//                               //  if (logincheck) {
//                               checkItemInCart(model.shortInfo, context);
//                               // } else {
//                               //   Route route = MaterialPageRoute(
//                               //       builder: (_) => AuthenticScreen());
//                               //   Navigator.push(context, route);
//                               // }
//                             })
//                         : IconButton(
//                             icon: Icon(
//                               Icons.delete,
//                               color: Colors.pinkAccent,
//                             ),
//                             onPressed: () {
//                               removeCartFunction();

//                               // Route route = MaterialPageRoute(
//                               //     builder: (c) => StoreHome());
//                               // Navigator.pushReplacement(context, route);
//                             }),
//                   ),
//                   Divider(height: 5.0, color: Colors.black),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
//   return Container(
//     height: 150.0,
//     width: width * 0.34,
//     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     decoration: BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//               offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
//         ]),
//     child: ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         child: Image.network(
//           imgPath,
//           height: 150.0,
//           width: width * 0.34,
//           fit: BoxFit.fill,
//         )),
//   );
// }

// void checkItemInCart(String productID, BuildContext context) {
//   EcommerceApp.sharedPreferences
//           .getStringList(EcommerceApp.userCartList)
//           .contains(productID)
//       ? Fluttertoast.showToast(msg: "Item is Already in the Cart!")
//       : addItemToCart(productID, context);
// }

// addItemToCart(String productID, BuildContext context) {
//   List tempCartList =
//       EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
//   tempCartList.add(productID);

//   EcommerceApp.firestore
//       .collection(EcommerceApp.collectionUser)
//       .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .updateData({
//     EcommerceApp.userCartList: tempCartList,
//   }).then((v) {
//     Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");
//     EcommerceApp.sharedPreferences
//         .setStringList(EcommerceApp.userCartList, tempCartList);
//     Provider.of<CartItemCounter>(context, listen: false).displayResult();
//   });
// }
