import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/maps_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(selectedPlace.title)),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 20),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 20),
          FlatButton(
            padding: const EdgeInsets.all(15),
            child: Text(
              'View on Map',
              style: TextStyle(fontSize: 18),
            ),
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                      MapsScreen(initialLocation: selectedPlace.location),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
