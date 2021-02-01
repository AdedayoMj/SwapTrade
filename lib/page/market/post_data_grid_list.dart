import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/shared/loading.dart';
import 'package:swap/widget/post_profile_pic.dart';

import 'package:swap/page/market/postlist_data.dart';

class PostDataList extends StatefulWidget {
  final String query;

  const PostDataList({Key key, this.query}) : super(key: key);
  @override
  _PostDataListState createState() => _PostDataListState();
}

class _PostDataListState extends State<PostDataList> {
  bool showSpinner;

  @override
  void initState() {
    super.initState();
    showSpinner = true;

    Timer(Duration(milliseconds: 300), () {
      setState(() {
        showSpinner = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadPost = Provider.of<List<PostItem>>(context) ?? [];
    final checkComplete =
        loadPost.where((e) => e.isCompleted == false).toList();
    final postItem = widget.query.isEmpty
        ? checkComplete
        : checkComplete
            .where((element) =>
                element.city.contains(widget.query) ||
                element.itemName.contains(widget.query))
            .toList();

    return showSpinner
        ? Loading()
        : Container(
            child: loadPost.isNotEmpty
                ? Container(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: postItem.length,
                      padding: EdgeInsets.all(2.0),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PostList(postData: postItem[index]),
                            ));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Hero(
                              tag: postItem[index].itemImages[0],
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        postItem[index].itemImages[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.black,
                                            const Color(0x19000000),
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 1.0),
                                          end: const FractionalOffset(0.0, 0.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FadeAnimation(
                                            0.6,
                                            Text(
                                              postItem[index].itemName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          FadeAnimation(
                                            0.6,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${postItem[index].city}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white),
                                                ),
                                                PostProfilePicture(
                                                    userIdPost:
                                                        postItem[index].userId)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ), /* add child content here */
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      'No Trade Item Available',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor),
                    ),
                  ),
          );
  }
}
