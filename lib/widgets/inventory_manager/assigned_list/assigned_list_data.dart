import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/screens/inventory_manager/assigned_list/assigned_list_details.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/get_details.dart';
import 'package:sealine_app/widgets/search.dart';

class AssignedListData extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseServices services;

  const AssignedListData({
    Key? key,
    required this.snapshot,
    required this.services,
  }) : super(key: key);

  @override
  State<AssignedListData> createState() => _AssignedListDataState();
}

class _AssignedListDataState extends State<AssignedListData> {
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
            Map<String, dynamic> assignedListData =
                widget.snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;

            var id = widget.snapshot.data!.docs[index].id;

            List<dynamic> sellerList = assignedListData['sellerList'];

            if (searchText.isEmpty ||
                assignedListData['fishType']
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                assignedListData['requestedBy']
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase())) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AssignedListDetails(
                          id: id,
                          assignedListData: assignedListData,
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
                          child: Fish(fishName: assignedListData['fishType']),
                        ),
                        const SizedBox(height: 10),
                        // Fish Name
                        Text(
                          assignedListData['fishType'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        sellerList.length == 1
                            ? Column(
                                children: [
                                  // Owner
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 80,
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Text('Owner'),
                                      ),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                        height: 30,
                                        width: 100,
                                        child: ListView.builder(
                                          itemCount: sellerList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Text(
                                                    sellerList[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Buyer
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 80,
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Text('Buyer'),
                                      ),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                        height: 30,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              assignedListData['requestedBy'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  // Owner(s)
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Text('Owner(s)'),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            // shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: sellerList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Container(
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Text(
                                                      sellerList[index]['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Buyer
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Text('Buyer'),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Container(
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Text(
                                                    assignedListData[
                                                        'requestedBy'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
