import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/screens/inventory_manager/inventories/im_inventory_details.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/get_details.dart';
import 'package:sealine_app/widgets/search.dart';

class BoatOwnerInventoriesData extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseServices services;

  const BoatOwnerInventoriesData({
    Key? key,
    required this.snapshot,
    required this.services,
  }) : super(key: key);

  @override
  State<BoatOwnerInventoriesData> createState() =>
      _BoatOwnerInventoriesDataState();
}

class _BoatOwnerInventoriesDataState extends State<BoatOwnerInventoriesData> {
  String searchText = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Search
        SearchField(
          controller: controller,
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          fillColor: Colors.grey[300],
        ),
        const SizedBox(height: 20),
        ListView.builder(
          padding: const EdgeInsets.all(15.0),
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.snapshot.data!.size,
          itemBuilder: (context, index) {
            Map<String, dynamic> boatOwnerInventoryData =
                widget.snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;

            var id = widget.snapshot.data!.docs[index].id;

            if (searchText.isEmpty ||
                boatOwnerInventoryData['fishType']
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                boatOwnerInventoryData['seller']['sellerName']
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase())) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IMInventoryDetails(
                          id: id,
                          boatOwnerInventoryData: boatOwnerInventoryData,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.teal, Colors.white],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Image
                        Container(
                          height: 80,
                          width: 100,
                          color: Colors.grey[400],
                          child: Fish(
                              fishName: boatOwnerInventoryData['fishType']),
                        ),
                        const SizedBox(height: 10),
                        // Fish Name
                        Text(
                          boatOwnerInventoryData['fishType'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                            'Owner - ${boatOwnerInventoryData['seller']['sellerName']}'),
                        const SizedBox(height: 5),
                        Text('Date - ${boatOwnerInventoryData['date']}'),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ],
    );
  }
}
