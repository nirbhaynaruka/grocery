import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Address/address.dart';
import 'package:grocery/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/main.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressID;
  final double totalAmount;
  PaymentPage({
    Key key,
    this.addressID,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _controller = TextEditingController();
  Widget button = Container();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffffff8),
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Place Order",
            style: TextStyle(
              fontSize: 25.0,
              letterSpacing: 1.5,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            const AndroidNotificationDetails androidPlatformChannelSpecifics =
                AndroidNotificationDetails('your channel id',
                    'your channel name', 'your channel description',
                    importance: Importance.max,
                    priority: Priority.high,
                    showWhen: false);
            const NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);
            await flutterLocalNotificationsPlugin.show(
                0,
                "Your Order has been Placed!",
                "Order Address ID : " + widget.addressID,
                platformChannelSpecifics,
                payload: 'item x');
            Route route = MaterialPageRoute(builder: (c) => addOrderDetails());
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => addOrderDetails(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          },
          label: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              "Place Order",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: "Folks-Heavy",
              ),
            ),
          ),
          backgroundColor: Color(0xff94b941),
          icon: Icon(
            Icons.done_all,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: Text(
                        "Order Summary",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  // width: screenWidth * 1,
                  child: Table(
                    border: TableBorder.all(width: 1.0),
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Order Address: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.addressID),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Order Items: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString()),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Sub Total: "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Rs. " + widget.totalAmount.toString()),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Delivery"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("*(Extra \u{20B9}${20} per km will be charged on the order price less then \u{20B9}${200})" 
                            ),
                          ),
                        ],
                      ),
                      // TableRow(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: KeyText(msg: "Coupon Code(applied):"),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(widget.addressID),
                      //     ),
                      //   ],
                      // ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: KeyText(msg: "Total"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("Rs. " + (widget.totalAmount.toString())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icon(
                //   Icons.shopping_basket_outlined,
                //   size: 100.0,
                //   color: Color(0xff94b941),
                // ),
                // SizedBox(height: 30.0),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.2),
                //           spreadRadius: 2,
                //           blurRadius: 5,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ]),
                //   child: FlatButton(
                //       onPressed: () => addOrderDetails(),
                //       color: Colors.white,
                //       textColor: Color(0xff94b941),
                //       padding: EdgeInsets.all(8.0),
                //       splashColor: Color(0xff94b941),
                //       child: Text(
                //         "Place Order",
                //         style: TextStyle(fontSize: 30.0),
                //       )),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    final xyz = DateTime.now().millisecondsSinceEpoch.toString();
    writeOrderDetalilsforUser({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash On delivery",
      EcommerceApp.orderTime: xyz,
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderDetails: "Ready to ship",
    });
    writeOrderDetalilsforAdmin({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash On delivery",
      EcommerceApp.orderTime: xyz,
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderDetails: "Ready to ship",
      // "track" : ""
    }).whenComplete(() => {emptyCartNow()});
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    Firestore.instance
        .collection("users")
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(
        msg: "Congrats, Your Order has been Placed Succesfully");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future writeOrderDetalilsforUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }

  Future writeOrderDetalilsforAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }
}
