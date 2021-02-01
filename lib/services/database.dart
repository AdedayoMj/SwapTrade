import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap/model/chat.dart';
import 'package:swap/model/offer.dart';
import 'package:swap/model/post.dart';
import 'package:swap/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({
    this.uid,
  });

//collection reference
  final CollectionReference _swapUsersCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _swapTradesCollection =
      FirebaseFirestore.instance.collection("trades");
  final CollectionReference _swapOffersCollection =
      FirebaseFirestore.instance.collection("offers");
  final CollectionReference _swapChatRoomCollection =
      FirebaseFirestore.instance.collection("chatroom");

  Future updateUserData(
    String firstName,
    String lastName,
    String username,
    String email,
    String urlProfile,
    String address,
    String city,
    String state,
    String country,
    String phoneNumber,
    int starRatings,
    Timestamp createdAt,
  ) async {
    return await _swapUsersCollection.doc(uid).set({
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "urlProfile": urlProfile,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      'starRatings': starRatings,
      "phoneNumber": phoneNumber,
      'createdAt': createdAt,
    });
  }

  Future addPostItemToFirebase({
    String userId,
    String username,
    String urlProfile,
    String city,
    String state,
    String itemName,
    List itemImages,
    String description,
    String itemExtimatedPrice,
    Timestamp postedAt,
    bool isCompleted,
  }) async {
    return await _swapTradesCollection.add({
      "userId": userId,
      "username": username,
      "urlProfile": urlProfile,
      "city": city,
      "state": state,
      'itemName': itemName,
      "itemImages": itemImages,
      'description': description,
      'itemExtimatedPrice': description,
      'postedAt': postedAt,
      'isCompleted': isCompleted,
    });
  }

  Future addSwapOfferItemToFirebase({
    String userId,
    String tadeSwapId,
    String username,
    String urlProfile,
    String itemName,
    List itemImages,
    String description,
    String itemExtimatedPrice,
    Timestamp postedAt,
  }) async {
    return await _swapOffersCollection.add({
      "userId": userId,
      "tadeSwapId": tadeSwapId,
      "username": username,
      "urlProfile": urlProfile,
      'itemName': itemName,
      "itemImages": itemImages,
      'description': description,
      'itemExtimatedPrice': itemExtimatedPrice,
      'postedAt': postedAt,
    });
  }

  Future updatePostItemToFirebase(
      {String userId,
      String username,
      String urlProfile,
      String city,
      String state,
      String itemName,
      List itemImages,
      String description,
      String itemExtimatedPrice,
      Timestamp postedAt,
      String documentId,
      bool isCompleted}) async {
    return await _swapTradesCollection.doc(documentId).set({
      "userId": userId,
      "username": username,
      "urlProfile": urlProfile,
      "city": city,
      "state": state,
      'itemName': itemName,
      "itemImages": itemImages,
      'description': description,
      'itemExtimatedPrice': itemExtimatedPrice,
      'postedAt': postedAt,
      'documentId': documentId,
      'isCompleted': isCompleted,
    });
  }

//user data from snapshots
  SwapUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return SwapUserData(
      uid: uid,
      firstName: snapshot.data()['firstName'],
      lastName: snapshot.data()['lastName'],
      username: snapshot.data()['username'],
      email: snapshot.data()['email'],
      urlProfile: snapshot.data()['urlProfile'],
      address: snapshot.data()['address'],
      city: snapshot.data()['city'],
      state: snapshot.data()['state'],
      country: snapshot.data()['country'],
      phoneNumber: snapshot.data()['phoneNumber'],
      createdAt: snapshot.data()['createdAt'],
    );
  }

  // get peopole list from snapshot
  List<PeopleData> _peopleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PeopleData(
        userId: doc.data()['userId'],
        username: doc.data()['username'],
        urlProfile: doc.data()['urlProfile'],
        firstName: doc.data()['firstName'] ?? '',
        lastName: doc.data()['lastName'] ?? '',
      );
    }).toList();
  }

  // get post list from snapshot
  List<PostItem> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostItem(
        userId: doc.data()['userId'],
        username: doc.data()['username'],
        urlProfile: doc.data()['urlProfile'],
        city: doc.data()['city'] ?? '',
        state: doc.data()['state'] ?? '',
        itemName: doc.data()['itemName'] ?? '',
        itemImages: doc.data()['itemImages'] ?? [],
        documentId: doc.id,
        itemExtimatedPrice: doc.data()['itemExtimatedPrice'] ?? '0',
        description: doc.data()['description'] ?? '',
        postedAt: doc.data()['postedAt'],
        isCompleted: doc.data()['isCompleted'],
      );
    }).toList();
  }

  // get post list from snapshot
  List<OfferItem> _offersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OfferItem(
        userId: doc.data()['userId'],
        username: doc.data()['username'],
        urlProfile: doc.data()['urlProfile'],
        itemName: doc.data()['itemName'] ?? '',
        itemImages: doc.data()['itemImages'] ?? [],
        documentId: doc.id,
        tadeSwapId: doc.data()['tadeSwapId'],
        itemExtimatedPrice: doc.data()['itemExtimatedPrice'] ?? '0',
        description: doc.data()['description'] ?? '',
        postedAt: doc.data()['postedAt'],
      );
    }).toList();
  }

  Stream<SwapUserData> get userInformation {
    return _swapUsersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<PeopleData>> get peopleInformationData {
    return _swapUsersCollection
        .orderBy(
          'username',
          descending: true,
        )
        .snapshots()
        .map(_peopleListFromSnapshot);
  }

  Stream<List<PostItem>> get tradeItemPost {
    return _swapTradesCollection
        .orderBy(
          'postedAt',
          descending: true,
        )
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Stream<List<OfferItem>> get swapOfferItemPost {
    return _swapOffersCollection.snapshots().map(_offersListFromSnapshot);
  }

  Future deletePost(String documentId) async {
    await _swapTradesCollection.doc(documentId).delete();
  }

  //Chat services
  createChatRoom(String charRoomId, chatRooomMap) {
    _swapChatRoomCollection.doc(charRoomId).set(chatRooomMap).catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection('chats')
        .snapshots();
  }
}
