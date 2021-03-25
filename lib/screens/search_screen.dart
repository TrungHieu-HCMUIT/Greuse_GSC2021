import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/ViewModels/news_feed_card_vm.dart';
import 'package:greuse/components/news_feed_card.dart';
import 'package:greuse/models/post.dart';
import 'package:greuse/models/user.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryController = TextEditingController();
  final _searchFiedlFocusNode = FocusNode();
  String _query;

  final _searchResults = <NewsFeedCardVM>[];

  void _fetchResults() {
    // TODO: Fetch news feed from sever and add to _searchResult
    _searchResults.addAll([
      NewsFeedCardVM(
        user: User(
          id: 'userid',
          displayname: 'khiemle',
          avatarURL: 'https://wallpapercave.com/wp/wp7999906.jpg',
          email: 'user@email.com',
        ),
        post: Post(
          id: 'postid',
          image:
              'https://thunggiay.com/wp-content/uploads/2018/10/Mua-thung-giay-o-dau-uy-tin-va-chat-luong1.jpg',
          material: 'Paper',
          name: 'Carton Box',
          location: 'TP HCM',
          description: 'Can be reused',
          isSaved: true,
          weight: 10,
        ),
      ),
    ]);
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
                return NewsFeedCard(_searchResults.elementAt(index));
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 25.0);
              },
            ),
    );
  }
}
