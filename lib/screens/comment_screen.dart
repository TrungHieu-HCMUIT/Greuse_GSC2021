import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  static const id = 'comment_screen';
  final String postId;
  CommentScreen(this.postId);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _controller = TextEditingController();
  String _comment = "";
  var _comments = <Map<String, dynamic>>[];

  Future<void> _fetchComment() async {
    final comments = await _firestore
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .get();
    if (comments.size > 0) {
      for (int i = 0; i < comments.size; i++) {
        final c = comments.docs[i].data();
        final user = await c['user'].get();
        _comments.add({
          ...c,
          'user': user.data(),
        });
      }
      setState(() {});
    }
  }

  Future<void> _postComment() async {
    final userId = _auth.currentUser.uid;
    if (userId == null) return;
    final dbUser = _firestore.collection("users").doc(userId);
    final res = await _firestore
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .add({
      'comment': _comment.trim(),
      'time': DateTime.now(),
      'user': dbUser,
    });
    if (res != null) {
      final user = await dbUser.get();
      res.update({'id': res.id});
      setState(() {
        _comments.add({
          'comment': _comment.trim(),
          'time': DateTime.now(),
          'user': user.data(),
        });
      });
      _controller.clear();
      _comment = '';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComment();
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final item = _comments.elementAt(index);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[100],
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(item['user']['photoUrl']),
                        ),
                        SizedBox(width: 10),
                        Text(
                          item['comment'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {
                        _comment = _controller.text.trim();
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: _comment.isEmpty ? null : _postComment,
                  icon:
                      ImageIcon(AssetImage('assets/icons/paper_air_plane.png')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
