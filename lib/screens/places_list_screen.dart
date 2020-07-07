import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/add_place_screen.dart';
import '../screens/place_detail_screen.dart';

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
                        itemBuilder: (_, i) => Dismissible(
                          key: ValueKey(greatPlaces.items[i].id),
                          background: Container(
                            color: Theme.of(context).errorColor,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(20),
                          ),
                          confirmDismiss: (_) => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'This action will remove this snap from Snap It!'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    await greatPlaces
                                        .removePlace(greatPlaces.items[i].id);
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[i].image)),
                            title: Text(greatPlaces.items[i].title),
                            subtitle:
                                Text(greatPlaces.items[i].location.address),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PlaceDetailScreen.routeName,
                                arguments: greatPlaces.items[i].id,
                              );
                            },
                          ),
                        ),
                        itemCount: greatPlaces.items.length,
                      ),
                child: Center(child: Text('Ya don\'t got no places yet')),
              ),
      ),
    );
  }
}
