import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/inventory_manager/assigned_list/assigned_list_data.dart';

class AssignedListStream extends StatelessWidget {
  const AssignedListStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: services.imInventory.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something wrong!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.size == 0) {
          return const Center(
            child: Text('Assigned List is empty'),
          );
        }

        return AssignedListData(snapshot: snapshot, services: services);
      },
    );
  }
}
