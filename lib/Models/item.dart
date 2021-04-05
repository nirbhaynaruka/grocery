import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String productId;
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  int price;
  int originalPrice;
  String catname;
  String catthumbnail;
  String subcatname;
  String subcatthumbnail;
  String bannerthumbnail;
  // int quantity;
  int newPrice;

  ItemModel({
    this.productId,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.catname,
    this.catthumbnail,
    this.subcatname,
    this.subcatthumbnail,
    this.bannerthumbnail,
    // this.quantity,
    this.newPrice,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    originalPrice = json['originalPrice'];
    catname = json['catname'];
    catthumbnail = json['catthumbnail'];
    subcatname = json['subcatname'];
    subcatthumbnail = json['subcatthumbnail'];
    bannerthumbnail = json['bannerthumbnail'];
    productId = json['productId'];
    // quantity = json['quantity'];
    newPrice = json['newPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    data['originalPrice'] = this.originalPrice;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data['catname'] = this.catname;
    data['subcatthumbnail'] = this.subcatthumbnail;
    data['productId'] = this.productId;
    // data['quantity'] = this.quantity;
    data['newPrice'] = this.newPrice;

    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
