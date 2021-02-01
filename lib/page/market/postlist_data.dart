import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/api/stream_channel_api.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/model/user.dart';
import 'package:swap/page/chat/chat.dart';
import 'package:swap/page/chat/chat_page.dart';
import 'package:swap/page/market/swap_offer_form_page.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';
import 'package:swap/widget/post_profile_pic.dart';

class PostList extends StatefulWidget {
  final PostItem postData;

  const PostList({Key key, this.postData}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: FadeAnimation(
          0.5,
          Text(widget.postData.itemName),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 600,
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // height: 300,
                    child: Hero(
                      tag: widget.postData.itemImages[0],
                      child: Container(
                        width: 350,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          // image: DecorationImage(
                          //   image:
                          //       NetworkImage(widget.postData.itemImages[0]),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        /* add child content here */
                        child: SliderPic(
                          postData: widget.postData,
                        ),
                      ),
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
                    PostProfilePicture(userIdPost: widget.postData.userId),
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 35.0,
                  right: 35.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    user.uid != widget.postData.userId
                        ? StreamBuilder<SwapUserData>(
                            stream:
                                DatabaseService(uid: user.uid).userInformation,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                SwapUserData userData = snapshot.data;
                                return FlatButton(
                                  color: kPrimaryColor,
                                  onPressed: () async {
                                    String chatRoomId = getChatRoomId(
                                        widget.postData.username,
                                        userData.username);

                                    List<String> users = [
                                      widget.postData.username,
                                      userData.username
                                    ];
                                    Map<String, dynamic> chatRoomMap = {
                                      'users': users,
                                      'chatroomid': chatRoomId,
                                      'sendBy': userData.username,
                                    };

                                    DatabaseService().createChatRoom(
                                        chatRoomId, chatRoomMap);

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          chatRoomId: chatRoomId,
                                          chatUserId: widget.postData.userId),
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
                                );
                              } else {
                                return Loading();
                              }
                            })
                        : Text(''),
                    FlatButton(
                      color: Colors.white,
                      onPressed: () {
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
              )
            ],
          ),
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }
}

class SliderPic extends StatefulWidget {
  final PostItem postData;

  const SliderPic({Key key, this.postData}) : super(key: key);
  @override
  _SliderPicState createState() => _SliderPicState();
}

class _SliderPicState extends State<SliderPic> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // color: Colors.red,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
              image: NetworkImage(widget.postData.itemImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      autoplay: false,
      itemCount: widget.postData.itemImages.length,
      pagination: SwiperPagination(),
      control: SwiperControl(),
    );
  }
}
