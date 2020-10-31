import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();

  final scafflodKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cCity = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();

  int _selectedPinCode;

  List<int> pincode = [335001, 335002, 335003, 335004, 335005, 335006, 335007];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scafflodKey,
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Add New Address",
            style: TextStyle(
              letterSpacing: 1.3,
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
        // MyAppBar(),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: _selectedPinCode.toString(),
                phoneNumber: "+91"+cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                final snack =
                    SnackBar(content: Text("New Address added Successfully."));
                scafflodKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });

              // Route route = MaterialPageRoute(builder: (c) => StoreHome());
              // Navigator.push(context, route);
              Navigator.pop(context);
            }
          },
          label: Text("Done"),
          backgroundColor: Color(0xff94b941),
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      data: Icons.edit,
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      data: Icons.edit,
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      data: Icons.edit,
                      hint: "Flat Number / Street Number / House Number",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      data: Icons.edit,
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      data: Icons.edit,
                      hint: "State",
                      controller: cState,
                    ),
                    // MyTextField(
                    //   data: Icons.edit,
                    //   hint: "Pincode",
                    //   controller: cPinCode,
                    // ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                child: DropdownButton(
                  underline: Container(),
                  isExpanded: true,
                  // icon: Icon(Icons.edit),
                  hint: Row(
                    children: [
                      new Icon(
                        Icons.edit,
                        color: Color(0xff535c3f),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Please choose a Pincode',
                        style: TextStyle(
                          fontFamily: "Arial Bold",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff535c3f),
                        ),
                      ),
                    ],
                  ), // Not necessary for Option 1
                  value: _selectedPinCode,
                  onChanged: (int newValue) {
                    setState(() {
                      _selectedPinCode = newValue;
                    });
                  },
                  items: pincode.map((pincode) {
                    return DropdownMenuItem(
                      child: Row(
                        children: [
                          new Icon(
                            Icons.edit,
                            color: Color(0xff535c3f),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          new Text(
                            pincode.toString(),
                            style: TextStyle(
                              fontFamily: "Arial Bold",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xff535c3f),
                            ),
                          ),
                        ],
                      ),
                      value: pincode,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final IconData data;
  final String hint;
  final TextEditingController controller;

  const MyTextField({Key key, this.hint, this.controller, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
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
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: TextFormField(
          enableSuggestions: true,
          style: TextStyle(
            fontFamily: "Arial Bold",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: Color(0xff535c3f),
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              data,
              color: Color(0xff535c3f),
              size: 20,
            ),
            focusColor: Color(0xff535c3f),
            hintText: hint,
          ),
          validator: (val) => val.isEmpty ? "Field can not be empty." : null,
        ),
      ),
    );
  }
}
