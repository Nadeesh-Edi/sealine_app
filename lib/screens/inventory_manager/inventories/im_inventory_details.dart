import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/custom_drawer/inventory_manager_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/get_details.dart';
import 'package:sealine_app/widgets/logo.dart';
import 'package:sealine_app/widgets/only_text_input.dart';
import 'package:sealine_app/widgets/scf_msg.dart';
import 'dart:developer' as devtools show log;

class IMInventoryDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic> boatOwnerInventoryData;

  const IMInventoryDetails({
    Key? key,
    required this.id,
    required this.boatOwnerInventoryData,
  }) : super(key: key);

  @override
  State<IMInventoryDetails> createState() => _IMInventoryDetailsState();
}

class _IMInventoryDetailsState extends State<IMInventoryDetails> {
  final DrawerItems drawerItems = DrawerItems();
  final FirebaseServices services = FirebaseServices();
  final SCF _scf = SCF();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text(
          'Inventory Details',
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: ListView(
          children: [
            // Image
            Center(
              child: Container(
                height: 150,
                width: 250,
                color: Colors.grey[400],
                child:
                    Fish(fishName: widget.boatOwnerInventoryData['fishType']),
              ),
            ),
            // Fish Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Text(
                widget.boatOwnerInventoryData['fishType'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        FormattedText(text: 'Owner'),
                        FormattedText(text: 'Inventory Date'),
                        FormattedText(text: 'Boat Name'),
                        FormattedText(text: 'Selling Price'),
                        FormattedText(text: 'Status'),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: const [
                        FormattedText(text: '-'),
                        FormattedText(text: '-'),
                        FormattedText(text: '-'),
                        FormattedText(text: '-'),
                        FormattedText(text: '-'),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormattedText(
                            text: widget.boatOwnerInventoryData['seller']
                                ['sellerName']),
                        FormattedText(
                            text: widget.boatOwnerInventoryData['date']),
                        FormattedText(
                            text: widget.boatOwnerInventoryData['boatName']),
                        FormattedText(
                            text:
                                'Rs ${widget.boatOwnerInventoryData['expectPrice']} /kg'),
                        FormattedText(
                          text: widget.boatOwnerInventoryData['status'] == true
                              ? 'Available'
                              : 'Not Available',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Mark as Expired
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    try {
                      EasyLoading.show();
                      services.inventory.doc(widget.id).delete().then((value) {
                        EasyLoading.dismiss();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            inventoryManagerHomeRoute, (route) => false);
                      });
                    } catch (e) {
                      _scf.scaffoldMsg(
                        context: context,
                        msg: e.toString().toUpperCase(),
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  child: const Text(
                    'Mark as Expired',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Contact Seller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () async {
                    String sellerNo = widget.boatOwnerInventoryData['seller']
                        ['sellerContactNo'];

                    devtools.log(sellerNo);

                    await FlutterPhoneDirectCaller.callNumber(sellerNo);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Contact Seller',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.phone, color: Colors.black)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
