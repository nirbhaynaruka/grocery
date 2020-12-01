import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  Future getCarouselWidget() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("banner").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    var idx = 0;
    return Container(
        child: FutureBuilder(
            future: getCarouselWidget(),
            builder: (context, AsyncSnapshot snapshot) {
              List<NetworkImage> list = new List<NetworkImage>();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return new CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return new Text("fetch error");
                } else {
                  //Create for loop and store the urls in the list
                  for (int i = 0; i < snapshot.data.length; i++) {
                    debugPrint(snapshot.data.length.toString());
                  var url = snapshot.data[idx].data["bannerthumbnail"];
                    list.add(NetworkImage(
                        snapshot.data[idx].data["bannerthumbnail"]));
                    idx++;
                  }
                  return Center(
                    child: SizedBox(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width - 10,
                      child: new Carousel(
                        boxFit: BoxFit.cover,
                        images: snapshot.data[idx].data["bannerthumbnail"],
                        autoplay: true,
                        borderRadius: false,
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.lightGreenAccent,
                        indicatorBgPadding: 5.0,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1500),
                      ),
                    ),
                  );
                }
              }
            }));
    //   return Center(
    //     child: SizedBox(
    //       height: 200.0,
    //       width: MediaQuery.of(context).size.width-10,
    //       child: Carousel(

    //         images: [
    //       //      StreamBuilder<QuerySnapshot>(
    //       //     stream:Firestore.instance.collection("banner").snapshots(),
    //       //     builder: (context, snapshot) {
    //       //       return  snapshot.hasData
    //       //         ?
    //       //          ListView.builder(
    //       //               itemCount: snapshot.data.documents.length,
    //       //               itemBuilder: (context, index) {
    //       //                 ItemModel model = ItemModel.fromJson(
    //       //                     snapshot.data.documents[index].data);
    //       //                 return  NetworkImage(
    //       //                           bannerthumbnail: snapshot.data.documents[index].data["bannerthumbnail"],
    //       //                         );
    //       //               },
    //       //             )
    //       //         : Center(
    //       //             child: Container(),
    //       //           );

    //       //     },
    //       // ),
    //           NetworkImage(
    //               'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F1.png?alt=media&token=6c8c44ef-1ca7-44e0-a977-ea58c53323a2'),
    //           NetworkImage(
    //               'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F2.png?alt=media&token=677dcdfa-fec5-44ec-8ac8-1d110643f5fb'),
    //           NetworkImage(
    //               'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F3.png?alt=media&token=a3f97a6c-2256-4b1b-a3da-79516130a472'),
    //         ],
    //         autoplay: true,
    //         boxFit: BoxFit.cover,
    //         animationCurve: Curves.fastOutSlowIn,
    //         animationDuration: Duration(milliseconds: 1500),
    //         dotSize: 4.0,
    //         dotSpacing: 15.0,
    //         dotColor: Colors.lightGreenAccent,
    //         indicatorBgPadding: 5.0,
    //         // dotBgColor: Color().withOpacity(0.5),
    //         borderRadius: false,
    //       ),
    //     ),
    //   );
  }
}
