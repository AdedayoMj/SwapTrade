import 'package:cloud_firestore/cloud_firestore.dart';

class OfferItem {
  final String userId;
  final String tadeSwapId;
  final String username;
  final String urlProfile;
  final String itemName;
  final List itemImages;
  final String description;
  final String documentId;
  final String itemExtimatedPrice;
  final Timestamp postedAt;

  OfferItem({
    this.userId,
    this.tadeSwapId,
    this.username,
    this.urlProfile,
    this.itemName,
    this.itemImages,
    this.description,
    this.documentId,
    this.itemExtimatedPrice,
    this.postedAt,
  });
}
