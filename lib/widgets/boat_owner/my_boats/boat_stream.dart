import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/boat_owner/my_boats/boat_data.dart';

class BoatStream extends StatelessWidget {
  const BoatStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream:
          services.boat.where('uid', isEqualTo: services.user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something wrong!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.size == 0) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    // Search
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Create New
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 92, 252),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(addNewBoatRoute);
                        },
                        child: const Text(
                          'Create New',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text('No boats'),
              ),
            ],
          );
        }

        return BoatData(snapshot: snapshot, services: services);
      },
    );
  }
}
