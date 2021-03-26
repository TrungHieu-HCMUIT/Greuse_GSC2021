import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChooseLocationScreen extends StatefulWidget {
  static const id = 'choose_location_screen';
  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  final _queryController = TextEditingController();

  Future<void> _searchPlaces(String query) async {
    String queryUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyADkNpHyC6I8kTg51Lxm353fWy31s6GW1o&sessiontoken=1234567890";

    final res = await http.get(Uri.parse(queryUrl));
    print(res.body);
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
          icon: ImageIcon(AssetImage('assets/icons/back.png')),
        ),
        title: Text('Choose location'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              labelText: 'Search for your location',
            ),
            onChanged: (v) {
              _searchPlaces(v);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
