import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/screens/boat_owner/boat_details.dart';
import 'package:sealine_app/services/firebase_services.dart';

class BoatData extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseServices services;

  const BoatData({
    Key? key,
    required this.snapshot,
    required this.services,
  }) : super(key: key);

  @override
  State<BoatData> createState() => _BoatDataState();
}

class _BoatDataState extends State<BoatData> {
  String searchText = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Search
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.clear();
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
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
          const SizedBox(height: 20),
          ListView.builder(
            padding: const EdgeInsets.all(15.0),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.snapshot.data!.size,
            itemBuilder: (context, index) {
              Map<String, dynamic> boatData = widget.snapshot.data!.docs[index]
                  .data() as Map<String, dynamic>;

              var id = widget.snapshot.data!.docs[index].id;

              if (searchText.isEmpty ||
                  boatData['boatName']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  boatData['boatBrand']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  boatData['maxMembers']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BoatDetails(id: id, boatData: boatData),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15.0),
                      horizontalTitleGap: 50,
                      // Image
                      leading: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: boatData['boatImage'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      title: Text(boatData['boatName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(boatData['boatBrand']),
                          const SizedBox(height: 5),
                          Text(boatData['boatType']),
                          const SizedBox(height: 5),
                          Text('${boatData['maxMembers']} Crew Members'),
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
      ),
    );
  }
}
