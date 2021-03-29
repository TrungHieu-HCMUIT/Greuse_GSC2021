import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart' as us;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _queryController = TextEditingController();
  final _searchFiedlFocusNode = FocusNode();
  String _query;

  final _searchResults = <NewsFeedCardVM>[];

  void _fetchResults() async {
    setState(() {
      _searchResults.clear();
    });
    final postName = (await _firestore
            .collection("posts")
            .where("name", isEqualTo: _query)
            .get())
        .docs;
    final postDes = (await _firestore
            .collection("posts")
            .where("description", isEqualTo: _query)
            .get())
        .docs;
    final postMaterial = (await _firestore
            .collection("posts")
            .where("material", isEqualTo: _query)
            .get())
        .docs;
    final finalList = List.from(postName)
      ..addAll(postDes)
      ..addAll(postMaterial);

    for (int i = 0; i < finalList.length; i++) {
      final userId = _auth.currentUser.uid;
      final postData = finalList[i].data();
      final userData = (await postData['user'].get()).data();
      final isSaved = (await _firestore
                  .collection('users')
                  .doc(userId)
                  .collection("savedPosts")
                  .where('id', isEqualTo: postData['id'])
                  .get())
              .size ==
          1;

      final liked = (await _firestore
                  .collection('users')
                  .doc(userId)
                  .collection("likedPosts")
                  .where('id', isEqualTo: postData['id'])
                  .get())
              .size ==
          1;

      _searchResults.add(NewsFeedCardVM(
        user: us.User.fromJson(userData),
        post: Post.fromJson({
          ...postData,
          'isSaved': isSaved,
          'liked': liked,
        }),
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 400),
      () {
        _searchFiedlFocusNode.requestFocus();
      },
    );
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
        title: TextField(
          controller: _queryController,
          focusNode: _searchFiedlFocusNode,
          style: TextStyle(
            color: Color(0xFF264653),
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onTap: () {
            if (_queryController.text.contains('Result for ')) {
              _queryController.text = _query;
            }
          },
          onSubmitted: (_) async {
            _query = _queryController.text;
            _queryController.text = 'Result for "$_query"';
            setState(() {
              _fetchResults();
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _queryController.clear();
              setState(() {});
            },
            tooltip: 'Clear',
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: _queryController.text.isEmpty
          ? Container()
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 26.0,
                horizontal: 36.0,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final e = _searchResults.elementAt(index);
                return NewsFeedCard(
                  viewModel: e,
                  message: e.user.id != _auth.currentUser.uid,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 25.0);
              },
            ),
    );
  }
}
