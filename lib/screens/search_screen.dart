import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greuse/components/news_feed_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryController = TextEditingController();
  final _searchFiedlFocusNode = FocusNode();
  String _query;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withAlpha(39),
        iconTheme: IconThemeData(
          color: Color(0xFF264653),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: Icon(CupertinoIcons.chevron_back),
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
          onSubmitted: (_) {
            _query = _queryController.text;
            _queryController.text = 'Result for "${_query}"';
            setState(() {});
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
              itemBuilder: (context, index) {
                return NewsFeedCard();
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 25.0);
              },
              itemCount: 3),
    );
  }
}
