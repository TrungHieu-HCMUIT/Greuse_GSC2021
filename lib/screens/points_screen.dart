import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class PointsScreen extends StatefulWidget {
  static const id = 'points_screen';
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  var _rowsData = [];

  var _headerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  var _bodyTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMaterialRow();
  }

  void getMaterialRow() async {
    // TODO: For Loop dynamic table row within the list declaration itself.
    final dataList =
        await _firestore.collection('materials').orderBy('id').get();
    for (var row in dataList.docs) {
      _rowsData.add(row.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/exchange.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Exchanging board',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Table(
                    border: TableBorder.all(color: Colors.black12),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Material',
                              style: _headerTextStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Decomposition',
                              textAlign: TextAlign.center,
                              style: _headerTextStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Point',
                              textAlign: TextAlign.center,
                              style: _headerTextStyle,
                            ),
                          ),
                        ],
                      ),
                      for (var rowData in _rowsData)
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 8,
                            ),
                            child: TextButton(
                              // TODO: Popup Material detail when tap
                              onPressed: () {
                                print(rowData['Material']);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  rowData['Material'],
                                  style: _bodyTextStyle,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 8,
                            ),
                            child: Text(
                              rowData['Decomposition'],
                              textAlign: TextAlign.center,
                              style: _bodyTextStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 8,
                            ),
                            child: Text(
                              rowData['Point'],
                              textAlign: TextAlign.center,
                              style: _bodyTextStyle,
                            ),
                          ),
                        ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/store.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Awards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              AwardStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class AwardStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // TODO: StatelessWidget Snapshot Data from firestore
      stream: _firestore.collection('awards').orderBy('Point').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final allAwardData = snapshot.data.docs.reversed;

        List<ListViewItem> listViewItem = [];
        for (var awardData in allAwardData) {
          final award = awardData.data()['Award'];
          final description = awardData.data()['Description'];
          final enterprise = awardData.data()['Enterprise'];
          final point = awardData.data()['Point'];
          final photoURL = awardData.data()['photoURL'];

          final viewItem = ListViewItem(
            award: award,
            description: description,
            enterprise: enterprise,
            point: point,
            photoURL: photoURL,
          );

          listViewItem.add(viewItem);
        }
        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 30.0,
          ),
          children: listViewItem,
        );
      },
    );
  }
}

class ListViewItem extends StatelessWidget {
  final String award;
  final String description;
  final String enterprise;
  final int point;
  final String photoURL;

  ListViewItem(
      {this.award,
      this.description,
      this.enterprise,
      this.photoURL,
      this.point});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                photoURL,
                height: 75.0,
                width: 75.0,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enterprise,
                    style: TextStyle(
                      color: Color(0xFF868686),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              children: [
                Image.asset(
                  'assets/icons/point.png',
                  width: 42.0,
                  height: 42.0,
                ),
                SizedBox(height: 5.0),
                Text(
                  point.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
