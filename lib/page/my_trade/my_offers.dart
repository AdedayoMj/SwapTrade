import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:swap/constant/colors.dart';
import 'package:swap/model/offer.dart';
import 'package:swap/model/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swap/model/post.dart';
import 'package:swap/page/chat/chat.dart';
import 'package:swap/services/database.dart';
import 'package:swap/widget/post_profile_pic.dart';

class MyOffers extends StatefulWidget {
  @override
  _MyOffersState createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<OfferItem>>.value(
      value: DatabaseService().swapOfferItemPost,
      child: MyOffersList(),
    );
  }
}

class MyOffersList extends StatefulWidget {
  @override
  _MyOffersListState createState() => _MyOffersListState();
}

class _MyOffersListState extends State<MyOffersList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    final loadPost = Provider.of<List<OfferItem>>(context) ?? [];
    final myposts = loadPost.where((e) => e.userId.contains(user.uid)).toList();
    return Scaffold(
        body: myposts.isNotEmpty
            ? ListView.builder(
                itemCount: myposts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: <Widget>[
                            new IconSlideAction(
                              caption: 'Edit',
                              color: Colors.black45,
                              icon: Icons.more_horiz,
                              onTap: () => {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => EditPost(myposts: myposts[index]),
                                // ))
                              },
                            ),
                          ],
                          actionExtentRatio: 0.25,
                          child: Card(
                            elevation: 0.0,
                            color: kPrimaryColor,
                            child: ListTile(
                              onTap: () {
                                showModalBottomSheet(
                                    enableDrag: false,
                                    isDismissible: false,
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (ctx) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          // border:Border(bottom: BorderSide(color: Colors.white)),
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(25.0),
                                            topRight:
                                                const Radius.circular(25.0),
                                          ),
                                        ),
                                        child: OfferPostPreview(
                                          postData: myposts[index],
                                        ),
                                      );
                                    });
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => OfferPostPreview(
                                //       postData: myposts[index]),
                                // ));
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(myposts[index].itemImages[0]),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    myposts[index].itemName,
                                    // searchList[index].currencyName.toUpperCase(),

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    myposts[index].username,
                                    // searchList[index].username,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white10),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text('You have not offered any swap trade'),
              ));
  }
}

class OfferPostPreview extends StatefulWidget {
  final OfferItem postData;

  const OfferPostPreview({Key key, this.postData}) : super(key: key);
  @override
  _OfferPostPreviewState createState() => _OfferPostPreviewState();
}

class _OfferPostPreviewState extends State<OfferPostPreview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 40,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 180,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      image: DecorationImage(
                        image: NetworkImage(widget.postData.itemImages[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    /* add child content here */
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              ' ${widget.postData.itemName}',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Value: ${widget.postData.itemExtimatedPrice}',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Description:',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          // widget.postData.description.isNotEmpty
                          //     ?
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 350,
                                  maxHeight: 350,
                                  minWidth: 350,
                                  minHeight: 20,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.postData.description,
                                  ),
                                ),
                              ),
                            ),
                          )
                          // : Text(''),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OppSwapItem(document: widget.postData.tadeSwapId)
          ],
        ),
      ),
    );
  }
}

class OppSwapItem extends StatefulWidget {
  final String document;

  const OppSwapItem({Key key, this.document}) : super(key: key);
  @override
  _OppSwapItemState createState() => _OppSwapItemState();
}

class _OppSwapItemState extends State<OppSwapItem> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostItem>>.value(
      value: DatabaseService().tradeItemPost,
      child: OppSwap(documentId: widget.document),
    );
  }
}

class OppSwap extends StatefulWidget {
  final String documentId;

  const OppSwap({Key key, this.documentId}) : super(key: key);
  @override
  _OppSwapState createState() => _OppSwapState();
}

class _OppSwapState extends State<OppSwap> {
  @override
  Widget build(BuildContext context) {
    final loadPost = Provider.of<List<PostItem>>(context) ?? [];
    final myposts = loadPost
        .where((e) => e.documentId.contains(widget.documentId))
        .toList();
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: myposts.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Icon(
                    Icons.swap_vert_circle_rounded,
                    size: 40,
                    color: myposts[index].isCompleted == true
                        ? Colors.red
                        : Colors.green,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              width: 180,
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      myposts[index].itemImages[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              /* add child content here */
                            ),
                            myposts[index].isCompleted == true
                                ? Transform.rotate(
                                    angle: 2 * pi / 12.0,
                                    child: Container(
                                      width: 180,
                                      height: 30,
                                      color: Colors.red,
                                      child: Text(
                                        "Swapped",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    ' ${myposts[index].itemName}',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Value: ${myposts[index].itemExtimatedPrice}',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'City: ${myposts[index].city}',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Description:',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),

                                // widget.postData.description.isNotEmpty
                                //     ?
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 350,
                                        maxHeight: 350,
                                        minWidth: 350,
                                        minHeight: 20,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          myposts[index].description,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                // : Text(''),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PostProfilePicture(
                                userIdPost: myposts[index].userId),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              myposts[index].username,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 17,
                              ),
                            )
                          ],
                        ),
                        myposts[index].isCompleted == false
                            ? FlatButton(
                                color: kPrimaryColor,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Chat(),
                                  ));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  'Chat',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
