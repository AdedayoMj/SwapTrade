import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/auth.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';
import 'package:swap/page/profile/account_edit.dart';
import 'package:swap/page/profile/address_edit.dart';
import 'package:swap/widget/avatar.dart';
import 'package:swap/page/profile/phone_edit.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  bool account = false;
  bool phone = false;
  bool address = false;
  File profilePic;

  void toggleView() {
    setState(() => account = !account);
  }

  void toggleViewPhone() {
    setState(() => phone = !phone);
  }

  void toggleViewAddress() {
    setState(() => address = !address);
  }

  clear() {
    setState(() {
      profilePic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: user.uid).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Avatar(
                          avatarUrl: userData?.urlProfile,
                          onTap: () async {
                            var pickedFile = await ImagePicker()
                                .getImage(source: ImageSource.gallery);

                            if (pickedFile != null) {
                              final FirebaseStorage _storage =
                                  FirebaseStorage.instanceFor(
                                      bucket:
                                          'gs://swaptrade-2e285.appspot.com');
                              String filePath = 'user/profile/${user.uid}.png';
                              Reference storageRef =
                                  _storage.ref().child(filePath);
                              await storageRef.putFile(File(pickedFile.path));
                              String url = (await storageRef.getDownloadURL())
                                  .toString();

                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                userData.firstName,
                                userData.lastName,
                                userData.username,
                                userData.email,
                                url,
                                userData.address,
                                userData.city,
                                userData.state,
                                userData.country,
                                userData.phoneNumber,
                                userData.starRatings,
                                userData.createdAt,
                              );
                              // uploadPic(context, profilePic);
                            } else {
                              print('No image selected.');
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            await DatabaseService(uid: user.uid).updateUserData(
                              userData.firstName,
                              userData.lastName,
                              userData.username,
                              userData.email,
                              '',
                              userData.address,
                              userData.city,
                              userData.state,
                              userData.country,
                              userData.phoneNumber,
                              userData.starRatings,
                              userData.createdAt,
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: kPrimaryColor,
                            ),
                            child: Center(
                              child: Text(
                                "Reset",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("Welcome ${userData?.username}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleView();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ]),
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Account',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        account
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 40,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        account
                            ? Container(
                                height: 250,
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    AccountEdit(),
                                              ));
                                            },
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Username -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.username,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'First Name -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.firstName,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Last Name -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.lastName,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Email -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.email,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleViewPhone();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ]),
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone Number',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        phone
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        phone
                            ? Container(
                                height: 100,
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    PhoneEdit(),
                                              ));
                                            },
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Mobile -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.phoneNumber,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleViewAddress();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ]),
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        address
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 40,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        address
                            ? Container(
                                height: 250,
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressEdit(),
                                              ));
                                            },
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Address -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              userData.address,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'State -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.state,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'City -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.city,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Country -',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userData.country,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
