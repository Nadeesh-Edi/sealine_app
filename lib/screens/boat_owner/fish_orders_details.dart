import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sealine_app/screens/inventory_manager/assigned_list/assigned_list_details.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/custom_drawer/boat_owner_customer_custom_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';

class FishOrdersDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic>? fishOrderData;

  const FishOrdersDetails({
    Key? key,
    required this.id,
    this.fishOrderData,
  }) : super(key: key);

  @override
  State<FishOrdersDetails> createState() => _FishOrdersDetailsState();
}

class _FishOrdersDetailsState extends State<FishOrdersDetails> {
  final FirebaseServices services = FirebaseServices();
  final DrawerItems drawerItems = DrawerItems();

  @override
  Widget build(BuildContext context) {
    String uid = services.user!.uid;

    int qty = widget.fishOrderData!['sellerMap'][uid]['imQty'];
    int unitPrice =
        int.parse(widget.fishOrderData!['sellerMap'][uid]['expectPrice']);
    int price = qty * unitPrice;

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 20),
              FormattedFishOrderDetails(
                text1: 'Fish Type',
                text2: widget.fishOrderData!['fishType'],
              ),
              FormattedFishOrderDetails(
                text1: 'Buyer',
                text2: widget.fishOrderData!['requestedBy'],
              ),
              FormattedFishOrderDetails(
                text1: 'Address',
                text2: widget.fishOrderData!['customerAddress'],
              ),
              FormattedFishOrderDetails(
                text1: 'Quantity',
                text2: '${qty}kg',
              ),
              FormattedFishOrderDetails(
                text1: 'Unit Price',
                text2: 'Rs. $unitPrice.00',
              ),
              FormattedFishOrderDetails(
                text1: 'Price',
                text2: 'Rs. $price.00',
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Accept
                  ElevatedButton(
                    onPressed: () {
                      try {
                        services.order
                            .doc(widget.fishOrderData!['customerDocID'])
                            .update(
                          {
                            'status': true,
                          },
                        );
                        services.imInventory.doc(widget.id).update(
                          {
                            'sellerMap.$uid.acceptStatus': true,
                          },
                        ).then((value) => Navigator.of(context).pop());
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 20),
                  // Decline
                  ElevatedButton(
                    onPressed: () {
                      try {
                        services.order
                            .doc(widget.fishOrderData!['customerDocID'])
                            .update(
                          {
                            'status': false,
                          },
                        );
                        services.imInventory.doc(widget.id).update({
                          'sellerMap.$uid.acceptStatus': false,
                        }).then((value) => Navigator.of(context).pop());
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: const Text('Decline'),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              // Contact Buyer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    CallButton(
                      text: 'Contact Buyer',
                      containerColor: Colors.lightGreen,
                      onPressed: () async {
                        String buyerNo =
                            widget.fishOrderData!['customePhoneNo'];

                        await FlutterPhoneDirectCaller.callNumber(buyerNo);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormattedFishOrderDetails extends StatelessWidget {
  const FormattedFishOrderDetails({
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
          flex: 1,
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
          flex: 2,
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
