import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greuse/models/user.dart' as us;

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  final String receiverId;
  ChatScreen(this.receiverId);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _messageController = TextEditingController();
  DocumentReference _sender;
  DocumentReference _receiver;
  Query _chatRef;
  us.User _senderInfo;
  us.User _receiverInfo;

  Future<void> _sendMessage() async {
    String userId = _auth.currentUser.uid;
    String message = _messageController.text.trim();
    final chatRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("messages")
        .where("user", isEqualTo: _receiver);
    final chat = await chatRef.get();
    await chat.docs[0].data()['chat'].collection("messages").add({
      'message': message,
      'sender': _sender,
      'receiver': _receiver,
      'time': DateTime.now(),
    });
    _messageController.text = '';
  }

  Future<void> _checkIfAlreadyChated() async {
    String userId = _auth.currentUser.uid;

    _sender = _firestore.collection("users").doc(userId);
    _receiver = _firestore.collection("users").doc(widget.receiverId);
    final senderInfo = (await _sender.get()).data();
    final receiverInfo = (await _receiver.get()).data();
    setState(() {
      _senderInfo = us.User.fromJson(senderInfo);
      _receiverInfo = us.User.fromJson(receiverInfo);
    });

    final chat = await _firestore
        .collection("users")
        .doc(userId)
        .collection("messages")
        .where("user", isEqualTo: _receiver)
        .get();
    if (chat.size == 0) {
      final chatRef = await _firestore.collection("chats").add({
        'user1': _sender,
        'user2': _receiver,
      });
      await _sender.collection("messages").add({
        'chatId': chatRef.id,
        'chat': chatRef,
        'user': _receiver,
      });
      await _receiver.collection("messages").add({
        'chatId': chatRef.id,
        'chat': chatRef,
        'user': _sender,
      });
      _chatRef =
          chatRef.collection('messages').orderBy("time", descending: true);
      setState(() {});
    } else {
      _chatRef = chat.docs[0]
          .data()['chat']
          .collection('messages')
          .orderBy("time", descending: true);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyChated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: ImageIcon(AssetImage('assets/icons/back.png')),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: _receiverInfo != null
                  ? NetworkImage(_receiverInfo.avatarURL)
                  : AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(width: 10),
            Text(
                _receiverInfo == null ? 'username' : _receiverInfo.displayname),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _chatRef == null
                ? Container()
                : StreamBuilder(
                    stream: _chatRef.snapshots(),
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (stream.hasError) {
                        return Center(child: Text('Error'));
                      }
                      if (stream.hasData) {
                        QuerySnapshot querySnapshot = stream.data;
                        final messages = querySnapshot.docs;
                        return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.all(8.0),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Message(
                                message: messages[index]['message'] ?? 'null',
                                photoUrl: messages[index]['sender'] == _sender
                                    ? _senderInfo.avatarURL
                                    : _receiverInfo.avatarURL,
                                // photoUrl:
                                //     'https://lh3.googleusercontent.com/a-/AOh14Gg7FGPUVvCX8a_17bayVGMzcRBi97C3Sc04Augx=s96-c',
                              );
                            });
                      }
                      return Container();
                    },
                  ),
          ),
          Divider(
            height: 0,
            indent: 0,
            color: Colors.black54,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: ImageIcon(
                    AssetImage('assets/icons/image.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Type here...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  icon: ImageIcon(
                    AssetImage('assets/icons/paper_air_plane.png'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String photoUrl;
  final String message;
  Message({
    @required this.photoUrl,
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
