import 'package:flutter/material.dart';
import 'package:greuse/components/awards_body.dart';

class AwardScreen extends StatelessWidget {
  final awardName;
  final description;
  final enterprise;
  final point;
  final photoURL;

  AwardScreen(
      {@required this.awardName,
      @required this.description,
      @required this.enterprise,
      @required this.point,
      @required this.photoURL});

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
          color: Colors.teal[400],
        ),
      ),
      body: AwardsBody(
        awardName: awardName,
        description: description,
        enterprise: enterprise,
        point: point,
        photoURL: photoURL,
      ),
    );
  }
}
