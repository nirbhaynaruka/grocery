import 'package:flutter/material.dart';

void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool success = false;
  int _user=0;
  String _select = "select";
  String _selectsub = "ok";
  var categories = <String>[
    'Beauty & Hygeine',
    'Beverages and Snacks',
    'Cleaning & Household',
    'Cooking Essentials',
    'Dairy Products',
    'Fruits & Vegetables',
    'Packaged Foods',
    'Miscellaneous'
    ];
  static List<List<String>> subCategories = [
     ['a', 'b', 'c'],
    ['d', 'e', 'f'],
    ['g', 'h', 'i'],
    ['j', 'k', 'l'],
    ['m', 'n', 'o'],
    ['p', 'q', 'r'],
    ['s', 't', 'u'],
    ['v', 'w', 'x']
  ];
  // static List<bool> activeCategories = List.filled(categories.length, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            // value: categories[_user],
            items: categories.map((val) {
              return DropdownMenuItem(
                child: Text(val),
                value: val,
              );
            }).toList(),
            hint: Text("$_select"), // Not necessary for Option 1
            onChanged: (val) {
              // setState(() {
              _select = val;
              _user = categories.indexOf(val);
              // });
              this.setState(() {});
            },
          ),
          Text("$_user"),
          DropdownButton(
            // value: _selectedcategory,
            items: subCategories[_user].map((subval) {
              return DropdownMenuItem(
                child: Text(subval),
                value: subval,
              );
            }).toList(),
            hint: Text("$_selectsub"), // Not necessary for Option 1
            onChanged: (val) {
              // setState(() {
              _selectsub = val;
              // });
              this.setState(() {});
            },
          ),
        ],
      ),
    )

        // ListView.builder(
        //   itemCount: categories.length,
        //   itemBuilder: (context, index) {
        //     return Column(
        //       children: <Widget>[
        //         SizedBox(
        //           height: 50,
        //           child: Center(
        //             child: RaisedButton(
        //               onPressed: () {
        //                 setState(() {
        //                   activeCategories[index] =
        //                       activeCategories.elementAt(index) == true
        //                           ? false
        //                           : true;
        //                 });
        //               },
        //               child: Text(
        //                 categories.elementAt(index),
        //               ),
        //             ),
        //           ),
        //         ),
        //         activeCategories.elementAt(index)
        //             ? ListView.builder(
        //                 shrinkWrap: true,
        //                 itemCount: subCategories.length,
        //                 itemBuilder: (context, subIndex) {
        //                   return DropdownButton(
        //                     // value: _selectedcategory,
        //                     items: categories.map((val) {
        //                       return DropdownMenuItem(
        //                         child: Text(val),
        //                         value: val,
        //                       );
        //                     }).toList(),
        //                     hint: Text("oiujhv"), // Not necessary for Option 1
        //                     onChanged: (val) {
        //                       // setState(() {
        //                       // _selectedcategory = val;
        //                       // });
        //                       this.setState(() {});
        //                     },
        //                   );

        //                   // SizedBox(
        //                   //   height: 50,
        //                   //   child: Center(
        //                   //     child: Text(subCategories
        //                   //         .elementAt(index)
        //                   //         .elementAt(subIndex)),
        //                   //   ),
        //                   // );
        //                 },
        //               )
        //             : SizedBox(),
        //       ],
        //     );
        //   },
        // ),
        );
  }
}
