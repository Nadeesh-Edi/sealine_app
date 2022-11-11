import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sealine_app/provider/inventory_provider.dart';
import 'package:sealine_app/screens/inventory_manager/buyer_requests/add_inv.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/custom_drawer/inventory_manager_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/logo.dart';
import 'package:sealine_app/widgets/only_text_input.dart';

class BuyerReqDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic>? customerOrderData;

  const BuyerReqDetails({
    Key? key,
    required this.id,
    this.customerOrderData,
  }) : super(key: key);

  @override
  State<BuyerReqDetails> createState() => _BuyerReqDetailsState();
}

class _BuyerReqDetailsState extends State<BuyerReqDetails> {
  final DrawerItems drawerItems = DrawerItems();
  final FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    DateTime date = (widget.customerOrderData!['date'] as Timestamp).toDate();

    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.teal,
          appBar: AppBar(
            title: const Text(
              'Buyer Requests',
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
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuyerReqFormattedText(
                        text1: 'Fish Type',
                        text2: widget.customerOrderData!['product'],
                      ),
                      BuyerReqFormattedText(
                        text1: 'Requested Date',
                        text2: DateFormat.yMd().format(date),
                      ),
                      BuyerReqFormattedText(
                        text1: 'Requested by',
                        text2: widget.customerOrderData!['name'],
                      ),
                      BuyerReqFormattedText(
                        text1: 'Quantity',
                        text2: '${widget.customerOrderData!['qty']} kg',
                      ),
                    ],
                  ),
                ),
              ),
              // ADD INVENTORY
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 34, 2, 150),
                        Color.fromARGB(255, 60, 63, 248),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        provider.getData(
                          fishType: widget.customerOrderData!['product'],
                          customerPhoneNo: widget.customerOrderData!['phoneNo'],
                          customerAddress: widget.customerOrderData!['address'],
                          customerDocID: widget.id,
                          customerEmail: widget.customerOrderData!['email'],
                          customerQty:
                              widget.customerOrderData!['qty'].toString(),
                          customerStatus: widget.customerOrderData!['status'],
                          customerUID: widget.customerOrderData!['uid'],
                          requestedBy: widget.customerOrderData!['name'],
                          requestedDate: DateFormat.yMd().format(date),
                        );
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddInv(),
                      ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'ADD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'INVENTORY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Contact Buyer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      String sellerNo = widget.customerOrderData!['phoneNo'];

                      await FlutterPhoneDirectCaller.callNumber(sellerNo);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Contact Buyer',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.phone, color: Colors.black)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
