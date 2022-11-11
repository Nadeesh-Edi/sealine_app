import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/custom_drawer/inventory_manager_drawer.dart';
import 'package:sealine_app/widgets/get_details.dart';
import 'package:sealine_app/widgets/logo.dart';
import 'package:sealine_app/widgets/only_text_input.dart';

class AssignedListDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic> assignedListData;

  const AssignedListDetails({
    Key? key,
    required this.id,
    required this.assignedListData,
  }) : super(key: key);

  @override
  State<AssignedListDetails> createState() => _AssignedListDetailsState();
}

class _AssignedListDetailsState extends State<AssignedListDetails> {
  final DrawerItems drawerItems = DrawerItems();
  double scrollPosition = 0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> sellerList = widget.assignedListData['sellerList'];

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text(
          'Assigned List',
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
                child: Fish(fishName: widget.assignedListData['fishType']),
              ),
            ),
            // Fish Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                widget.assignedListData['fishType'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
            ),
            SizedBox(
              height: 370,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: sellerList.length,
                    onPageChanged: (value) {
                      setState(() {
                        scrollPosition = value.toDouble();
                      });
                    },
                    itemBuilder: (context, index) {
                      int total = sellerList[index]['imQty'] *
                          int.parse(sellerList[index]['expectPrice']);

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BuyerReqFormattedText(
                                    text1: 'Owner',
                                    text2: sellerList[index]['name'],
                                  ),
                                  BuyerReqFormattedText(
                                    text1: 'Inventory Date',
                                    text2: sellerList[index]['date'],
                                  ),
                                  BuyerReqFormattedText(
                                    text1: 'Buyer',
                                    text2:
                                        widget.assignedListData['requestedBy'],
                                  ),
                                  BuyerReqFormattedText(
                                    text1: 'Quantity',
                                    text2: '${sellerList[index]['imQty']}kg',
                                  ),
                                  BuyerReqFormattedText(
                                    text1: 'Total Price',
                                    text2: 'Rs. ${total.toString()}.00',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                // Buyer
                                CallButton(
                                  text: 'Buyer',
                                  containerColor: Colors.lightGreen,
                                  onPressed: () async {
                                    String buyerNo = widget
                                        .assignedListData['customePhoneNo'];

                                    await FlutterPhoneDirectCaller.callNumber(
                                        buyerNo);
                                  },
                                ),
                                const SizedBox(width: 20),
                                // Seller
                                CallButton(
                                  text: 'Seller',
                                  containerColor:
                                      const Color.fromARGB(255, 0, 3, 185),
                                  onPressed: () async {
                                    String buyerNo =
                                        sellerList[index]['phoneNo'];

                                    await FlutterPhoneDirectCaller.callNumber(
                                        buyerNo);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: DotsIndicator(
                      dotsCount: sellerList.length,
                      position: scrollPosition,
                      decorator: const DotsDecorator(
                        color: Colors.grey,
                        activeColor: Color.fromARGB(255, 33, 53, 167),
                        size: Size(18, 9),
                        activeSize: Size(18, 9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  final String text;
  final Color? containerColor;
  final void Function()? onPressed;

  const CallButton({
    Key? key,
    required this.text,
    this.containerColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.phone, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
