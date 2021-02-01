import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/user.dart';
import 'package:swap/page/market/swap_offer_form_page.dart';
import 'package:provider/provider.dart';
import 'package:swap/model/post.dart';
import 'package:swap/services/database.dart';
import 'package:swap/page/chat/chat.dart';

class PeopleListData extends StatefulWidget {
  final PeopleData postData;

  const PeopleListData({Key key, this.postData}) : super(key: key);
  @override
  _PeopleListDataState createState() => _PeopleListDataState();
}

class _PeopleListDataState extends State<PeopleListData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.postData.username),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: widget.postData.urlProfile.isNotEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.postData.urlProfile),
                        )
                      : CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 60,
                          child: Text(
                            widget.postData.username[0].toUpperCase(),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'List of Active Swap Items',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: UserPost(
                username: widget.postData.username,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserPost extends StatefulWidget {
  final String username;

  const UserPost({Key key, this.username}) : super(key: key);
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostItem>>.value(
      value: DatabaseService().tradeItemPost,
      child: MyPostList(username: widget.username),
    );
  }
}

class MyPostList extends StatefulWidget {
  final String username;

  const MyPostList({Key key, this.username}) : super(key: key);
  @override
  _MyPostListState createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  @override
  Widget build(BuildContext context) {
    final loadPost = Provider.of<List<PostItem>>(context) ?? [];
    final checkComplete =
        loadPost.where((e) => e.isCompleted == false).toList();
    final myposts = checkComplete
        .where((e) => e.username.contains(widget.username))
        .toList();
    return myposts != null
        ? GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: myposts.length,
            padding: EdgeInsets.all(2.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: false,
                      isDismissible: false,
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            // border:Border(bottom: BorderSide(color: Colors.white)),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: UserPostPreview(
                            postData: myposts[index],
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      image: DecorationImage(
                        image: NetworkImage(myposts[index].itemImages[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          gradient: new LinearGradient(
                              colors: [
                                Colors.black,
                                const Color(0x19000000),
                              ],
                              begin: const FractionalOffset(0.0, 1.0),
                              end: const FractionalOffset(0.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                myposts[index].itemName,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${myposts[index].city}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), /* add child content here */
                  ),
                ),
              );
            },
          )
        : Text(
            'User does not have any active swap item',
            style: TextStyle(
              color: Colors.red,
            ),
          );
  }
}

class UserPostPreview extends StatefulWidget {
  final PostItem postData;

  const UserPostPreview({Key key, this.postData}) : super(key: key);
  @override
  _UserPostPreviewState createState() => _UserPostPreviewState();
}

class _UserPostPreviewState extends State<UserPostPreview> {
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: widget.postData.itemImages[0],
                        child: Container(
                          width: 350,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            image: DecorationImage(
                              image:
                                  NetworkImage(widget.postData.itemImages[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          /* add child content here */
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          'City: ${widget.postData.city}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 5),
                        child: Text(
                          'Description:',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 350,
                        maxHeight: 250,
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 35.0,
                      right: 35.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.pop(context);
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
                        ),
                        FlatButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SwapOfferFormPage(
                                  postDocument: widget.postData.documentId),
                            ));
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: kPrimaryColor,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            'Trade',
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
