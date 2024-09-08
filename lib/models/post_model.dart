import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String itemName;
  String lostDistrict;
  String lostLocation;
  String postId;
  String itemType;
  String itemFeature;
  var lostTime;
  var datePublished;
  String pic;
  bool status;
  List<Map> fixways;

  PostModel({
    required this.itemName,
    required this.itemType,
    required this.lostDistrict,
    required this.lostLocation,
    this.datePublished,
    this.lostTime,
    required this.itemFeature,
    required this.postId,
    required this.pic,
    required this.status,
    required this.fixways,
  });

  static Map toMap(PostModel cart) {
    return {
      "itemName": cart.itemName,
      "itemType": cart.itemType,
      "lostDistrict": cart.lostDistrict,
      "lostLocation": cart.lostLocation,
      "datePublished": cart.datePublished,
      "postId": cart.postId,
      "pic": cart.pic,
      "status": cart.status,
      "itemFeature": cart.itemFeature,
      "lostTime": cart.lostTime,
      "fixways": cart.fixways,
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return PostModel(
      itemName: snapshot['itemName'],
      itemType: snapshot['itemType'],
      lostDistrict: snapshot['lostDistrict'],
      lostLocation: snapshot['lostLocation'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      pic: snapshot['pic'],
      status: snapshot["status"],
      itemFeature: snapshot["itemFeature"],
      lostTime: snapshot["lostTime"],
      fixways: snapshot["fixways"],
    );
  }

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemType": itemType,
        "lostDistrict": lostDistrict,
        "lostLocation": lostLocation,
        "datePublished": datePublished,
        "postId": postId,
        "pic": pic,
        "status": status,
        "itemFeature": itemFeature,
        "lostTime": lostTime,
        "fixways": fixways,
      };

  static PostModel fromMap(Map map) {
    return PostModel(
      itemName: map['itemName'],
      itemType: map['itemType'],
      lostDistrict: map['lostDistrict'],
      lostLocation: map['lostLocation'],
      datePublished: map['datePublished'],
      postId: map['postId'],
      pic: map['pic'],
      status: map["status"],
      itemFeature: map["itemFeature"],
      lostTime: map["lostTime"],
      fixways: map["fixways"],
    );
  }
}
