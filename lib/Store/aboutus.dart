import 'package:flutter/material.dart';
import 'package:grocery/Widgets/wideButton.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Aboutus extends StatefulWidget {
  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "About Us",
            style: TextStyle(
              // fontSize: 25.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                  child: Column(
                children: [
                  Image.asset(
                    "assets/icons/new_logo_white.jpg",
                    height: 220.0,
                    width: 220.0,
                  ),
                  Row(
                    children: <Widget>[
                       Expanded(
                        flex:1,
                        child:SizedBox(width: 10.0,),
                      ),
                      new Expanded(
                        flex: 2,
                        child: WideButton(
                        message: "Call - 1",
                        onPressed: () => UrlLauncher.launch("tel://9799120841"),
                      ),
                      ),
                      Expanded(
                        flex:1,
                        child:SizedBox(width: 10.0,),
                      ),
                      new Expanded(
                        flex: 2,
                        child:WideButton(
                        message: "Call - 2",
                        onPressed: () => UrlLauncher.launch("tel://9358965687"),
                      ),
                      ),
                       Expanded(
                        flex:1,
                        child:SizedBox(width: 10.0,),
                      ),
                       new Expanded(
                        flex: 2,
                        child:WideButton(
                        message: "Call - 3",
                        onPressed: () => UrlLauncher.launch("tel://7073237761"),
                      ),
                      ),
                       Expanded(
                        flex:1,
                        child:SizedBox(width: 10.0,),
                      ),
                    ],
                  ),
                  WideButton(
                    message: "Mail Us",
                    onPressed: () => UrlLauncher.launch(
                        "mailto:naturecoopfresh2020@gmail.com?subject=To Nature Coop Fresh&body= Hello,"),
                  ),
                ],
              )),
              Divider(color: Colors.black),
              Expanded(
                flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Designed and Developed By :",
                  style: TextStyle(
                    fontWeight:FontWeight.bold),
                    ),
                  Image.asset(
                    "assets/icons/twp.jpeg",
                    height: 220.0,
                    width: 220.0,
                  ),
                  WideButton(
                    message: "Mail Us",
                    onPressed: () => UrlLauncher.launch(
                        "mailto:heywhitepage@gmail.com?subject=To The White Page&body= Hello,"),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
