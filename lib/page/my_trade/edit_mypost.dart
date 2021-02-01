import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';

import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';

class EditPost extends StatefulWidget {
  final PostItem myposts;

  const EditPost({Key key, this.myposts}) : super(key: key);
  @override
  _EditPostState createState() => new _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();
  // ignore: deprecated_member_use
  List<Asset> images = List<Asset>();
  List files = [];
  List<String> urlLinks = [];
  String _itemName;
  String _valuePrice;
  String _description;

  String _stateValue;
  String _cityValue;
  int maxLength = 15;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    // final images
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
              'Swap Item Updated successfully!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: const Text('Edit'),
        backgroundColor: kPrimaryColor,
      ),
      body: !loading
          ? Container(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                Column(
                                  children: <Widget>[
                                    // Center(child: Text('Error: ${images.length}')),
                                    RaisedButton(
                                      child: Text("Upload images"),
                                      onPressed: loadAssets,
                                    ),
                                    Container(
                                        height: 150,
                                        child: images.isNotEmpty
                                            ? buildGridView()
                                            : GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: widget
                                                    .myposts.itemImages.length,
                                                padding: EdgeInsets.all(2.0),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    height: 300,
                                                    width: 300,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff7c94b6),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            widget.myposts
                                                                    .itemImages[
                                                                index]),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                })),

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
                                        initialValue: widget.myposts?.itemName,
                                        validator: (val) => val.isEmpty
                                            ? 'Enter an Item Name'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            _itemName = val;
                                          });
                                        },
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(30)
                                        ],
                                        decoration: new InputDecoration(
                                          labelText: "Item Name",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.money_outlined),
                                      title: TextFormField(
                                        initialValue:
                                            widget.myposts?.itemExtimatedPrice,
                                        validator: (val) => val.isEmpty
                                            ? 'Enter the Item Value Price'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            _valuePrice = val;
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                          labelText: "Item Value Price",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
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
                                        initialValue: widget.myposts?.city,
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
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.streetview),
                                      title: TextFormField(
                                        initialValue: widget.myposts?.state,
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
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.description),
                                      title: TextFormField(
                                        initialValue:
                                            widget.myposts?.description,
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
                                                new BorderRadius.circular(25.0),
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
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = false;
                                      });
                                      for (int i = 0; i < images.length; i++) {
                                        var path2 = await FlutterAbsolutePath
                                            .getAbsolutePath(
                                                images[i].identifier);
                                        var file =
                                            await getImageFileFromAsset(path2);

                                        final FirebaseStorage _storage =
                                            FirebaseStorage.instanceFor(
                                                bucket:
                                                    'gs://swaptrade-2e285.appspot.com');
                                        String filePath =
                                            'trades/post/${DateTime.now()}.png';
                                        Reference storageRef =
                                            _storage.ref().child(filePath);
                                        await storageRef
                                            .putFile(File(file.path));
                                        String url =
                                            (await storageRef.getDownloadURL())
                                                .toString();
                                        urlLinks.add(url);
                                      }
                                      await DatabaseService()
                                          .updatePostItemToFirebase(
                                        userId: widget.myposts.userId,
                                        username: widget.myposts.username,
                                        urlProfile: widget.myposts.urlProfile,
                                        city: _cityValue ?? widget.myposts.city,
                                        state:
                                            _stateValue ?? widget.myposts.state,
                                        itemName: _itemName ??
                                            widget.myposts.itemName,
                                        itemImages: urlLinks.isNotEmpty
                                            ? urlLinks
                                            : widget.myposts.itemImages,
                                        description: _description ??
                                            widget.myposts.description,
                                        itemExtimatedPrice: _valuePrice ??
                                            widget.myposts.itemExtimatedPrice,
                                        postedAt: widget.myposts.postedAt,
                                        documentId: widget.myposts.documentId,
                                        isCompleted: widget.myposts.isCompleted,
                                      );
                                      await switchOff();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 250,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kPrimaryColor,
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Update',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Loading(),
    );
  }
}
