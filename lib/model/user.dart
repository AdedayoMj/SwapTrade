import 'package:cloud_firestore/cloud_firestore.dart';

class CustomeUser {
  final String uid;
  final bool emailVerified;
  final bool isUserloggedin;
  CustomeUser({this.isUserloggedin, this.uid, this.emailVerified});
}

class SwapUserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String urlProfile;
  final String address;
  final String city;
  final String state;
  final String country;
  final String phoneNumber;
  final int starRatings;
  final Timestamp createdAt;

  SwapUserData({
    this.uid,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.urlProfile,
    this.address,
    this.city,
    this.state,
    this.country,
    this.phoneNumber,
    this.starRatings,
    this.createdAt,
  });
}

class PeopleData {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String urlProfile;

  PeopleData({
    this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.urlProfile,
  });
}
