import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/inventory_manager/inventories/boat_owner_inventories_data.dart';

class BoatOwnerInventoriesStream extends StatelessWidget {
  const BoatOwnerInventoriesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: services.inventory
          // .where('uid', isEqualTo: services.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something wrong!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.size == 0) {
          return const Center(
            child: Text('No inventories'),
          );
        }

        return BoatOwnerInventoriesData(snapshot: snapshot, services: services);
      },
    );
  }
}
