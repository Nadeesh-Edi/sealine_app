import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/screens/boat_owner/fish_orders_details.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/search.dart';

class FishOrdersData extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseServices services;

  const FishOrdersData({
    Key? key,
    required this.snapshot,
    required this.services,
  }) : super(key: key);

  @override
  State<FishOrdersData> createState() => _FishOrdersDataState();
}

class _FishOrdersDataState extends State<FishOrdersData> {
  String searchText = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.snapshot.data!.size,
            itemBuilder: (context, index) {
              Map<String, dynamic> fishOrderData =
                  widget.snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;

              var id = widget.snapshot.data!.docs[index].id;

              String uid = widget.services.user!.uid;

              if (searchText.isEmpty ||
                  fishOrderData['requestedBy']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  fishOrderData['fishType']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  fishOrderData['sellerMap'][uid]['imQty']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FishOrdersDetails(
                          id: id,
                          fishOrderData: fishOrderData,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormattedFishOrders(
                                    text1: 'Name of Buyer',
                                    text2: fishOrderData['requestedBy'],
                                  ),
                                  FormattedFishOrders(
                                    text1: 'Fish Type',
                                    text2: fishOrderData['fishType'],
                                  ),
                                  FormattedFishOrders(
                                    text1: 'Qty',
                                    text2: '${fishOrderData['sellerMap'][uid]['imQty']}kg',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            fishOrderData['sellerMap'][uid]['acceptStatus'] == true
                                ? 'Accepted'
                                : 'Pending',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

class FormattedFishOrders extends StatelessWidget {
  const FormattedFishOrders({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
