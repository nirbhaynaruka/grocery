import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityPincode {
  String pincode;
  String city;

  CityPincode({
    this.pincode,
    this.city,
  });
}

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
  String _selectedPinCode = "Please select your pincode";
  String _selectedCity = "City";
  int _user = 0;
  var _selectedPinCodecat = <String>[
    "243234",
    "524",
    "752",
    "2754",
    "2754",
    "7542",
  ];
  static List<List<String>> _selectedCitycat = [
    ["Sriganganagar"],
    ["ef"],
    ["efs"],
    ["efsdf"],
    ["fsd"],
    ["gefsdf"],
  ];
  // List<int> pincode = [335001, 335002, 335003, 335004, 335005, 335006, 335007];
  // List<CityPincode> citypin = [
  //   CityPincode(city: "Sriganganagar", pincode: "335001"),
  //   CityPincode(city: "Sriganganagar1", pincode: "335002"),
  //   CityPincode(city: "Sriganganagar2", pincode: "335003"),
  //   CityPincode(city: "Sriganganagar3", pincode: "335004"),
  //   CityPincode(city: "Sriganganagar4", pincode: "335005"),
  //   CityPincode(city: "Sriganganagar5", pincode: "335006"),
  // ];

  @override
  Widget build(BuildContext context) {
    // String _selectedPinCode;
    // String _selectedPinCode;

    // String _selectedCity;

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
                state: "Rajasthan",
                pincode: _selectedPinCode.toString(),
                phoneNumber: "+91" + cPhoneNumber.text,
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
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Color(0xff535c3f),
                            size: 20,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          DropdownButton(
                            underline: Container(),
                            isExpanded: false,
                            // value: _selectedcategory,
                            items: _selectedPinCodecat.map((val) {
                              return DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color(0xff535c3f),
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(val),
                                  ],
                                ),
                                value: val,
                              );
                            }).toList(),
                            hint: Text(
                              "$_selectedPinCode",
                              style: TextStyle(
                                fontFamily: "Arial Bold",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ), // Not necessary for Option 1
                            onChanged: (val) {
                              // setState(() {
                              _selectedPinCode = val;
                              _user = _selectedPinCodecat.indexOf(val);
                              cCity.text = _selectedCitycat[_user].single;
                              // });
                              this.setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    // Text(_selectedCitycat[_user].single),
                    // Padding(
                    //   padding: EdgeInsets.all(0.0),
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           offset: Offset(0, 4),
                    //           blurRadius: 15,
                    //           color: Color(0xFFB7B7B7).withOpacity(.5),
                    //         ),
                    //       ],
                    //     ),
                    //     padding: EdgeInsets.all(5.0),
                    //     margin: EdgeInsets.symmetric(
                    //         horizontal: 10.0, vertical: 8.0),
                    //     child: TextFormField(
                    //       readOnly: true,
                    //       initialValue: _selectedCity,
                    //       enableSuggestions: true,
                    //       style: TextStyle(
                    //         fontFamily: "Arial Bold",
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       cursorColor: Color(0xff535c3f),
                    //       controller: cCity,
                    //       decoration: InputDecoration(
                    //         border: InputBorder.none,
                    //         prefixIcon: Icon(
                    //           Icons.edit,
                    //           color: Color(0xff535c3f),
                    //           size: 20,
                    //         ),
                    //         focusColor: Color(0xff535c3f),
                    //         hintText: "City",
                    //       ),
                    //       validator: (val) =>
                    //           val.isEmpty ? "Field can not be empty." : null,
                    //     ),
                    //   ),
                    // ),
                    // MyTextField(
                    //   data: Icons.edit,
                    //   hint: "City",
                    //   controller: cCity,
                    // ),
                    Padding(
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: 
                        TextFormField(
                          readOnly: true,
                          // initialValue: _selectedCitycat[_user].single,
                          enableSuggestions: true,
                          style: TextStyle(
                            fontFamily: "Arial Bold",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Color(0xff535c3f),
                          controller: cCity,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xff535c3f),
                              size: 20,
                            ),
                            focusColor: Color(0xff535c3f),
                            hintText: "City",
                          ),
                          validator: (val) =>
                              val.isEmpty ? "Field can not be empty." : null,
                        ),
                      ),
                    ),
                    Padding(
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: "Rajasthan",
                          enableSuggestions: true,
                          style: TextStyle(
                            fontFamily: "Arial Bold",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Color(0xff535c3f),
                          // controller: cState,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xff535c3f),
                              size: 20,
                            ),
                            focusColor: Color(0xff535c3f),
                            // hintText: ,
                          ),
                          validator: (val) =>
                              val.isEmpty ? "Field can not be empty." : null,
                        ),
                      ),
                    ),
                    // MyTextField(
                    //   data: Icons.edit,
                    //   hint: "State",
                    //   controller: cState,
                    // ),
                    // MyTextField(
                    //   data: Icons.edit,
                    //   hint: "Pincode",
                    //   controller: cPinCode,
                    // ),
                  ],
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
