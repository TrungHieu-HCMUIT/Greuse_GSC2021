import 'package:flutter/material.dart';

class AwardsBody extends StatelessWidget {
  final awardName;
  final description;
  final enterprise;
  final point;
  final photoURL;
  AwardsBody(
      {@required this.awardName,
      @required this.description,
      @required this.enterprise,
      @required this.point,
      @required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: 360,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(photoURL),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.only(top: 20.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    awardName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    // padding: EdgeInsets.all(15),
                    width: 100,
                    // decoration: BoxDecoration(
                    //     color: Colors.orange[800],
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(20),
                    //       bottomLeft: Radius.circular(20),
                    //     )),
                    child: Column(
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
                            // color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 100,
                    bottom: 20,
                  ),
                  child: Text(
                    description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Enterprise: $enterprise",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.orange[400]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal[400],
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                width: 200,
                height: 50,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: CLAIM REWARD
                    },
                    child: Text(
                      "Claim",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
