import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    });
  }

  Future<void> _checkIfAlreadyChated() async {
    String userId = _auth.currentUser.uid;

    _sender = _firestore.collection("users").doc(userId);
    _receiver = _firestore.collection("users").doc(widget.receiverId);

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
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(width: 10),
            Text('Username'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
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
