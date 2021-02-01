import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';

import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';

class PoatDataPage extends StatefulWidget {
  @override
  _PoatDataPageState createState() => new _PoatDataPageState();
}

class _PoatDataPageState extends State<PoatDataPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: deprecated_member_use
  List<Asset> images = List<Asset>();
  List files = [];
  List<String> urlLinks = [];
  String _itemName;
  String _valuePrice;
  String _description = '';

  String _stateValue;
  String _cityValue;
  int maxLength = 15;
  bool loading = false;
  bool switchToPay = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          margin: EdgeInsets.all(10),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    // ignore: deprecated_member_use
    List<Asset> resultList = List<Asset>();
    String error = 'Can only';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  switchOff() async {
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Swap Trade',
              style: TextStyle(color: kPrimaryColor),
            ),
            content: Text(
              'Swap Item added successfully!',
              style: TextStyle(fontSize: 15, color: kPrimaryColor),
            ),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  //Put your code here which you want to execute on Yes button click.
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Post Swap Item'),
          backgroundColor: kPrimaryColor,
        ),
        body: !switchToPay
            ? Container(
                child: !loading
                    ? Form(
                        key: _formKey,
                        child: StreamBuilder<SwapUserData>(
                          stream:
                              DatabaseService(uid: user.uid).userInformation,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              SwapUserData userData = snapshot.data;
                              final date1 = userData.createdAt.toDate();
                              Duration difference =
                                  DateTime.now().difference(date1);
                              Duration duration = const Duration(days: 60);
                              return SingleChildScrollView(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          // Center(child: Text('Error: ${images.length}')),
                                          RaisedButton(
                                            child: Text("Upload images"),
                                            onPressed: loadAssets,
                                          ),
                                          images.length > 0
                                              ? Container(
                                                  height: 120,
                                                  child: buildGridView(),
                                                )
                                              : Center(
                                                  child: Icon(
                                                    Icons.photo_camera,
                                                    color: kPrimaryColor,
                                                    size: 130,
                                                  ),
                                                ),
                                          Divider(color: Colors.black)
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.backpack),
                                            title: TextFormField(
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an Item Name'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  _itemName = val;
                                                });
                                              },
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    30)
                                              ],
                                              decoration: new InputDecoration(
                                                labelText: "Item Name",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.money_outlined),
                                            title: TextFormField(
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter the Item Value Price'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  _valuePrice = val;
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: new InputDecoration(
                                                labelText: "Item Value Price",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.home),
                                            title: TextFormField(
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter the city'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  _cityValue = val;
                                                });
                                              },
                                              decoration: new InputDecoration(
                                                labelText: "City",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.streetview),
                                            title: TextFormField(
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a State'
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  _stateValue = val;
                                                });
                                              },
                                              decoration: new InputDecoration(
                                                labelText: "State",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.description),
                                            title: TextField(
                                              onChanged: (val) {
                                                setState(() {
                                                  _description = val;
                                                });
                                              },
                                              maxLines: 4,
                                              decoration: new InputDecoration(
                                                labelText: "Desctiption",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            if (images.isNotEmpty) {
                                              if (userData
                                                  .phoneNumber.isNotEmpty) {
                                                if (difference.inDays >
                                                    duration.inDays) {
                                                  setState(() {
                                                    loading = false;
                                                    switchToPay = true;
                                                  });
                                                  print('You have to pay');
                                                } else {
                                                  for (int i = 0;
                                                      i < images.length;
                                                      i++) {
                                                    var path2 =
                                                        await FlutterAbsolutePath
                                                            .getAbsolutePath(
                                                                images[i]
                                                                    .identifier);

                                                    var file =
                                                        await getImageFileFromAsset(
                                                            path2);

                                                    final FirebaseStorage
                                                        _storage =
                                                        FirebaseStorage.instanceFor(
                                                            bucket:
                                                                'gs://swaptrade-2e285.appspot.com');
                                                    String filePath =
                                                        'trades/post/${DateTime.now()}.png';
                                                    Reference storageRef =
                                                        _storage
                                                            .ref()
                                                            .child(filePath);
                                                    await storageRef.putFile(
                                                        File(file.path));
                                                    String url = (await storageRef
                                                            .getDownloadURL())
                                                        .toString();
                                                    urlLinks.add(url);
                                                  }
                                                  await DatabaseService()
                                                      .addPostItemToFirebase(
                                                          userId: user.uid,
                                                          username: userData
                                                              .username,
                                                          urlProfile: userData
                                                              .urlProfile,
                                                          city:
                                                              _cityValue ??
                                                                  userData.city,
                                                          state: _stateValue ??
                                                              userData.state,
                                                          itemImages: urlLinks,
                                                          itemName: _itemName,
                                                          itemExtimatedPrice:
                                                              _valuePrice,
                                                          description:
                                                              _description,
                                                          postedAt:
                                                              Timestamp.now(),
                                                          isCompleted: false);
                                                  await switchOff();
                                                }
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Account',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor),
                                                        ),
                                                        content: Text(
                                                          'Please complete your profile and verify your phone number',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  kPrimaryColor),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              //Put your code here which you want to execute on Yes button click.
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Image',
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                                      content: Text(
                                                        'Please add item images',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text("Ok"),
                                                          onPressed: () {
                                                            //Put your code here which you want to execute on Yes button click.
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: kPrimaryColor,
                                          ),
                                          child: Center(
                                              child: Text(
                                            difference.inDays > duration.inDays
                                                ? 'Continue'
                                                : 'Submit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Loading();
                            }
                          },
                        ),
                      )
                    : Loading(),
              )
            : Container(
                color: Colors.red,
              ));
  }
}
