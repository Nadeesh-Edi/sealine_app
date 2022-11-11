import 'package:flutter/material.dart';
import 'package:sealine_app/widgets/boat_owner/fish_orders/fish_orders_stream.dart';
import 'package:sealine_app/widgets/custom_drawer/boat_owner_customer_custom_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';

class FishOrders extends StatefulWidget {
  const FishOrders({Key? key}) : super(key: key);

  @override
  State<FishOrders> createState() => _FishOrdersState();
}

class _FishOrdersState extends State<FishOrders> {
  @override
  Widget build(BuildContext context) {
    final DrawerItems drawerItems = DrawerItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Fish Orders',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
          const SizedBox(height: 20),
          const FishOrdersStream(),
        ],
      ),
    );
  }
}
