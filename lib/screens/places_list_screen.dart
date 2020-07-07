import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Your Places'),
        excludeHeaderSemantics: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).initialize(),
        builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                builder: (_, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemBuilder: (_, i) => ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(greatPlaces.items[i].image)),
                          title: Text(greatPlaces.items[i].title),
                          onTap: () {},
                        ),
                        itemCount: greatPlaces.items.length,
                      ),
                child: Center(child: Text('Ya don\'t got no places yet')),
              ),
      ),
    );
  }
}
