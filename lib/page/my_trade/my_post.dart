import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/page/my_trade/edit_mypost.dart';
import 'package:swap/page/my_trade/my_post_preview.dart';

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostItem>>.value(
      value: DatabaseService().tradeItemPost,
      child: MyPostList(),
    );
  }
}

class MyPostList extends StatefulWidget {
  @override
  _MyPostListState createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    final loadPost = Provider.of<List<PostItem>>(context) ?? [];
    final checkComplete =
        loadPost.where((e) => e.isCompleted == false).toList();
    final myposts =
        checkComplete.where((e) => e.userId.contains(user.uid)).toList();
    return myposts.isNotEmpty
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditPost(myposts: myposts[index]),
                            ))
                          },
                        ),
                        new IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Delete Trade',
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                      content: Text(
                                        'Do you want to delete post',
                                        style: TextStyle(
                                            fontSize: 15, color: kPrimaryColor),
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            //Put your code here which you want to execute on Yes button click.
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            _databaseService.deletePost(
                                                myposts[index].documentId);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.80,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      // border:Border(bottom: BorderSide(color: Colors.white)),
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: MyPostPreview(
                                      postData: myposts[index],
                                    ),
                                  );
                                });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(myposts[index].itemImages[0]),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                myposts[index].city,
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
            child: Text('You have no swap post'),
          );
  }
}
