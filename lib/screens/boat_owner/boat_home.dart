import 'package:flutter/material.dart';
import 'package:sealine_app/widgets/boat_owner/my_boats/boat_stream.dart';
import 'package:sealine_app/widgets/custom_drawer/boat_owner_customer_custom_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';

class BoatHome extends StatelessWidget {
  const BoatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerItems drawerItems = DrawerItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'SEALINE',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 3,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: BoatOwnerCustomDrawer(
        drawerItems: drawerItems.boatOwnerItems,
        routeList: drawerItems.boatOwnerNavItems,
      ),
      body: ListView(
        children: [
          Container(
            height: 5,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'My Boats',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const BoatStream(),
        ],
      ),
    );
  }
}
