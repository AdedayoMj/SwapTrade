import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
// import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:swap/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:swap/model/chat.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String chatUserId;

  const ChatPage({Key key, this.chatRoomId, this.chatUserId}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: user.uid).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;
            return ChatInstance(
              chatRoomId: widget.chatRoomId,
              username: userData.username,
              chatUserId: widget.chatUserId,
            );
          } else {
            return Loading();
          }
        });
  }
}

class ChatInstance extends StatefulWidget {
  final String chatRoomId;
  final String username;
  final String chatUserId;

  const ChatInstance({Key key, this.chatRoomId, this.username, this.chatUserId})
      : super(key: key);
  @override
  _ChatInstanceState createState() => _ChatInstanceState();
}

class _ChatInstanceState extends State<ChatInstance> {
  final messageHolder = TextEditingController();

  List<Chat> _chatConversationFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chat(
        message: doc.data()['message'] ?? '',
        sendBy: doc.data()['sendBy'] ?? '',
        timeSent: doc.data()['timeSent'] ?? '',
      );
    }).toList();
  }

  Stream<List<Chat>> get getUsersConversationMessages {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(widget.chatRoomId)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map(_chatConversationFromSnapshot);
  }

  sendMessage() {
    final user = Provider.of<CustomeUser>(context, listen: false);
    if (messageHolder.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageHolder.text.trim(),
        'sendBy': widget.username,
        'timeSent': Timestamp.now(),
        'userId': user.uid,
      };
      DatabaseService().addConversationMessages(widget.chatRoomId, messageMap);
      messageHolder.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Chat>>.value(
      value: getUsersConversationMessages,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Row(
            children: [
              UserPicture(
                chatUserId: widget.chatUserId,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.chatRoomId
                    .toString()
                    .replaceAll('_', '')
                    .replaceAll(widget.username, '')
                    .split(' ')
                    .map((word) => word[0].toUpperCase() + word.substring(1))
                    .join(' '),
              ),
            ],
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Container(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: ChatMessages(currentUser: widget.username),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.image,
                            color: kPrimaryColor,
                            size: 25,
                          ),
                          onPressed: () {}),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: messageHolder,
                          autocorrect: false,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: 'Message ...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}

class UserPicture extends StatefulWidget {
  final String chatUserId;

  const UserPicture({Key key, this.chatUserId}) : super(key: key);
  @override
  _UserPictureState createState() => _UserPictureState();
}

class _UserPictureState extends State<UserPicture> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: widget.chatUserId).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;

            return userData.urlProfile.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(userData.urlProfile),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      userData.username[0].toUpperCase(),
                      style: TextStyle(fontSize: 20, color: kPrimaryColor),
                    ),
                  );
            ;
          } else {
            return Loading();
          }
        });
  }
}

class ChatMessages extends StatefulWidget {
  final String currentUser;

  const ChatMessages({Key key, this.currentUser}) : super(key: key);
  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    final conversations = Provider.of<List<Chat>>(context);
    final DateFormat formatter = DateFormat('EEEE');

    // final String formatted = formatter.format(conversations.timeSent.toDate());

    return conversations != null
        ? GroupedListView<Chat, String>(
            elements: conversations,
            groupBy: (element) =>
                formatter.format(element.timeSent.toDate()).toString(),
            groupSeparatorBuilder: (groupByValue) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 15,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                  ),
                  child: Text(groupByValue,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      )),
                ),
              ),
            ),

            indexedItemBuilder: (context, Chat element, index) => MessageTile(
                conversations: element, currentUsername: widget.currentUser),
            itemComparator: (item1, item2) => formatter
                .format(item1.timeSent.toDate())
                .compareTo(
                    formatter.format(item2.timeSent.toDate())), // optional
            useStickyGroupSeparators: false, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
            reverse: true,
          )
        //  ListView.builder(
        //     reverse: true,
        //     itemCount: conversations.length,
        //     itemBuilder: (context, index) {
        //       return MessageTile(
        //           conversations: conversations[index],
        //           currentUsername: widget.currentUser);
        //     },
        //   )
        : Text('');
  }
}

class MessageTile extends StatelessWidget {
  final Chat conversations;
  final String currentUsername;

  MessageTile({Key key, this.conversations, this.currentUsername})
      : super(key: key);
  // ignore: missing_return
  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSendbyMe = conversations.sendBy == currentUsername;
    final DateFormat formatter = DateFormat('Hm');
    final String formatted = formatter.format(conversations.timeSent.toDate());

    // int timeInmillis = conversations.timeSent.millisecondsSinceEpoch;
    // var date = new DateTime.fromMillisecondsSinceEpoch(timeInmillis);

    return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.only(
            left: isSendbyMe ? 80 : 24, right: isSendbyMe ? 24 : 80),
        width: MediaQuery.of(context).size.width,
        alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: isSendbyMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23),
                      ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.8, 0.0),
                    colors: isSendbyMe
                        ? [kPrimaryColor, kPrimaryColor]
                        : [
                            Colors.blueGrey[800],
                            Colors.blueGrey[500],
                          ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversations.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  formatted,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            )));
  }
}
