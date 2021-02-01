import 'package:cloud_firestore/cloud_firestore.dart';

class PostItem {
  final String userId;
  final String username;
  final String urlProfile;
  final String city;
  final String state;
  final String itemName;
  final List itemImages;
  final String description;
  final String itemExtimatedPrice;
  final String documentId;
  final Timestamp postedAt;
  final bool isCompleted;

  PostItem({
    this.userId,
    this.username,
    this.urlProfile,
    this.city,
    this.state,
    this.itemName,
    this.itemImages,
    this.documentId,
    this.itemExtimatedPrice,
    this.description,
    this.postedAt,
    this.isCompleted,
  });
}
