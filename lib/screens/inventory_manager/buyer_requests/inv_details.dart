import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:sealine_app/provider/inventory_provider.dart';
import 'package:sealine_app/screens/inventory_manager/assigned_list/assigned_list.dart';
import 'package:sealine_app/screens/inventory_manager/buyer_requests/add_inv.dart';
import 'package:sealine_app/services/firebase_services.dart';
import 'package:sealine_app/widgets/custom_drawer/inventory_manager_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/only_text_input.dart';

class InvDetails extends StatefulWidget {
  const InvDetails({Key? key}) : super(key: key);

  @override
  State<InvDetails> createState() => _InvDetailsState();
}

class _InvDetailsState extends State<InvDetails> {
  final DrawerItems drawerItems = DrawerItems();
  final FirebaseServices services = FirebaseServices();

  Future<bool> _onWillPop() async {
    return (await Flushbar(
          title: 'Caution',
          message: 'All the inventory data will be cleared!',
          icon: const Icon(Icons.warning, color: Colors.white),
          shouldIconPulse: false,
          padding: const EdgeInsets.all(18),
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () {
              List<Map<String, dynamic>> list =
                  Provider.of<InventoryProvider>(context, listen: false)
                      .inventoryData['sellerList'];
              try {
                for (int i = 0; i < list.length; i++) {
                  services.inventory.doc(list[i]['docID']).update(
                    {
                      'qty': (int.parse(list[i]['qty']) + list[i]['imQty'])
                          .toString(),
                    },
                  );
                }
              } catch (e) {
                print(e.toString().toUpperCase());
              }
              Provider.of<InventoryProvider>(context, listen: false)
                  .clearItems();

              Provider.of<InventoryProvider>(context, listen: false)
                  .clearUIDs();

              Navigator.of(context).pop(true);
            },
            child: const Text('OK'),
          ),
        ).show(context)) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<InventoryProvider>(context);

    int buyerQty = int.parse(providerr.inventoryData['customerQty']);

    double sum = 0.0;

    providerr.inventoryData['sellerList'].forEach((element) {
      sum += element['imQty'];
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
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
            GreyBuyerDetails(providerr: providerr),
            SellerList(providerr: providerr),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add Inventory
                  Container(
                    height: 80,
                    width: 150,
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
                        if (buyerQty <= sum) {
                          Flushbar(
                            backgroundColor: Colors.red,
                            message: 'You can\'t add more inventories.',
                            icon: const Icon(Icons.info, color: Colors.white),
                            padding: const EdgeInsets.all(18),
                            duration: const Duration(seconds: 2),
                          ).show(context);
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddInv(),
                        ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // ADD
                          Text(
                            'ADD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          // INVENTORY
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
                  const SizedBox(width: 20),
                  // Submit
                  Container(
                    height: 80,
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 150, 34),
                          Color.fromARGB(255, 38, 230, 38),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Flushbar(
                          message: 'Do you want to submit?',
                          padding: const EdgeInsets.all(18),
                          duration: const Duration(seconds: 5),
                          mainButton: TextButton(
                            onPressed: () {
                              List list = providerr.inventoryData['sellerList'];

                              final sellerMap = {};

                              for (int i = 0; i < list.length; i++) {
                                final k = list[i]['uid'];
                                print('$i: $k');
                                sellerMap.addAll({k: list[i]});
                              }

                              providerr.getData(
                                sellerMap: sellerMap,
                                customerAssigned: true,
                              );

                              services.order
                                  .doc(providerr.inventoryData['customerDocID'])
                                  .update(
                                {
                                  'assigned': true,
                                },
                              );
                              try {
                                EasyLoading.show();
                                services
                                    .addIMInventory(
                                  data: providerr.inventoryData,
                                )
                                    .then((value) {
                                  if (providerr.inventoryData['sellerList'] !=
                                      null) {
                                    Provider.of<InventoryProvider>(context,
                                            listen: false)
                                        .clearItems();
                                  }

                                  if (providerr.inventoryData['sellerList'] !=
                                      null) {
                                    Provider.of<InventoryProvider>(context,
                                            listen: false)
                                        .clearUIDs();
                                  }
                                  EasyLoading.dismiss();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const AssignedList(),
                                  ));
                                });
                              } catch (e) {
                                Flushbar(
                                  message: e.toString().toUpperCase(),
                                  backgroundColor: Colors.red,
                                );
                              }
                            },
                            child: const Text('YES'),
                          ),
                        ).show(context);
                      },
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Contact Buyer
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 0, 80, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () async {
                    String buyerNo = providerr.inventoryData['customePhoneNo'];

                    await FlutterPhoneDirectCaller.callNumber(buyerNo);
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
      ),
    );
  }
}

class SellerList extends StatelessWidget {
  const SellerList({
    Key? key,
    required this.providerr,
  }) : super(key: key);

  final InventoryProvider providerr;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 250),
        child: ListView.builder(
          padding: const EdgeInsets.all(15.0),
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: providerr.inventoryData['sellerList'].length,
          itemBuilder: (context, index) {
            Map<String, dynamic> invInfoData =
                providerr.inventoryData['sellerList'][index];

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Container(
                height: 80,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.teal, Colors.white],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      invInfoData['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Date
                        Text(
                          '${invInfoData['date']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${invInfoData['imQty']} kg',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GreyBuyerDetails extends StatelessWidget {
  const GreyBuyerDetails({
    Key? key,
    required this.providerr,
  }) : super(key: key);

  final InventoryProvider providerr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
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
              text2: providerr.inventoryData['fishType'],
            ),
            BuyerReqFormattedText(
              text1: 'Requested Date',
              text2: providerr.inventoryData['requestedDate'],
            ),
            BuyerReqFormattedText(
              text1: 'Requested by',
              text2: providerr.inventoryData['requestedBy'],
            ),
            BuyerReqFormattedText(
              text1: 'Quantity',
              text2: '${providerr.inventoryData['customerQty']} kg',
            ),
          ],
        ),
      ),
    );
  }
}
