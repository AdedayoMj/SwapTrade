import 'package:flutter/material.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';

class PostProfilePicture extends StatefulWidget {
  final String userIdPost;

  const PostProfilePicture({Key key, this.userIdPost}) : super(key: key);
  @override
  _PostProfilePictureState createState() => _PostProfilePictureState();
}

class _PostProfilePictureState extends State<PostProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: widget.userIdPost).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;
            return CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(userData.urlProfile),
            );
          } else {
            return CircleAvatar(
              backgroundColor: Colors.white,
            );
          }
        });
  }
}
