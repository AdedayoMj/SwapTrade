import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final Function onTap;

  const Avatar({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: avatarUrl.isEmpty
            ? CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.photo_camera,
                  color: kPrimaryColor,
                ),
              )
            : CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(avatarUrl),
              ),
      ),
    );
  }
}
