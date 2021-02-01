import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomInfo {
  final String chatroomid;
  final String sendBy;
  final bool chatstatus;
  ChatRoomInfo({
    this.chatroomid,
    this.sendBy,
    this.chatstatus,
  });
}

class Chat {
  final String message;
  final String sendBy;
  final Timestamp timeSent;
  final String userId;
  // final bool unread;
  Chat({
    this.message,
    this.sendBy,
    this.timeSent,
    this.userId,
    // this.unread,
  });
}
