import 'package:flutter/material.dart';
import 'package:sealine_app/widgets/custom_drawer/inventory_manager_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/inventory_manager/inventories/boat_owner_inventories_stream.dart';
import 'package:sealine_app/widgets/logo.dart';

class InventoryManagerHome extends StatelessWidget {
  const InventoryManagerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerItems drawerItems = DrawerItems();

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text(
          'Inventories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.lightGreen,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Logo(),
            ),
          ),
        ],
      ),
      drawer: InventoryManagerCustomDrawer(
        drawerItems: drawerItems.inventoryManagerItems,
        routeList: drawerItems.inventoryManagerNavItems,
      ),
      body: const BoatOwnerInventoriesStream(),
    );
  }
}
