import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Arial Bold",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Color(0xff535c3f),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Color(0xff535c3f),
          ),
          focusColor: Color(0xff535c3f),
          hintText: hintText,
        ),
      ),
    );
  }
}
