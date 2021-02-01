import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/widget/post_profile_pic.dart';

class MyPostPreview extends StatefulWidget {
  final PostItem postData;

  const MyPostPreview({Key key, this.postData}) : super(key: key);
  @override
  _MyPostPreviewState createState() => _MyPostPreviewState();
}

class _MyPostPreviewState extends State<MyPostPreview> {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 15),
                    child: Row(
                      children: [
                        PostProfilePicture(
                          userIdPost: widget.postData.userId,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.postData.username,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 17,
                          ),
                        )
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
