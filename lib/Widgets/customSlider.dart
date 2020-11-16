import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class CarouselPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width-10,
        child: Carousel(
          
          images: [
             StreamBuilder<QuerySnapshot>(
            stream:Firestore.instance.collection("banner").snapshots(),
            builder: (context, snapshot) {
              return  snapshot.hasData
                ? 
                NetworkImage(
                               
                                  bannerthumbnail: snapshot.data.documents[index].data["bannerthumbnail"],
                                )
               
                : Center(
                    child: Container(),
                  );
              
            },
        ),
            // NetworkImage(
            //     'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F1.png?alt=media&token=6c8c44ef-1ca7-44e0-a977-ea58c53323a2'),
            // NetworkImage(
            //     'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F2.png?alt=media&token=677dcdfa-fec5-44ec-8ac8-1d110643f5fb'),
            // NetworkImage(
            //     'https://firebasestorage.googleapis.com/v0/b/groceryapp-e9d3f.appspot.com/o/Banner%2F3.png?alt=media&token=a3f97a6c-2256-4b1b-a3da-79516130a472'),
          ],
          autoplay: true,
          boxFit: BoxFit.cover,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1500),
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Colors.lightGreenAccent,
          indicatorBgPadding: 5.0,
          // dotBgColor: Color().withOpacity(0.5),
          borderRadius: false,
        ),
      ),
    );
  }
}
