import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/screens/customer/customer_bill.dart';
import 'package:sealine_app/widgets/buttons.dart';
import 'package:sealine_app/widgets/custom_drawer/customer_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/logo.dart';

class CustomerFishDetails extends StatefulWidget {
  final String id;
  final Map<String, dynamic> fishData;
  final String fishPrice;

  const CustomerFishDetails({
    Key? key,
    required this.id,
    required this.fishData,
    required this.fishPrice,
  }) : super(key: key);

  @override
  State<CustomerFishDetails> createState() => _CustomerFishDetailsState();
}

class _CustomerFishDetailsState extends State<CustomerFishDetails> {
  final DrawerItems _drawerItems = DrawerItems();
  late final TextEditingController _qty;

  @override
  void initState() {
    _qty = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _qty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Products Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
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
      drawer: CustomerCustomDrawer(
        drawerItems: _drawerItems.customerItems,
        routeList: _drawerItems.customerNavItems,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
            child: Column(
              children: [
                // Image
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.fishData['fishImage'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Fish Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        widget.fishData['fishName'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Rs. ${widget.fishPrice}.00',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.fishData['fishDescription'],
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Quantity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Enter Qty
                      const Text(
                        'Enter Quantity: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // TextField
                      Expanded(
                        child: SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _qty,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Order Now
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 176, 49),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_qty.text.isEmpty) {
                        Flushbar(
                          backgroundColor: Colors.red,
                          message: 'Quantity is required',
                          icon: const Icon(Icons.info, color: Colors.white),
                          padding: const EdgeInsets.all(18),
                          duration: const Duration(seconds: 2),
                        ).show(context);
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CustomerBill(
                            id: widget.id,
                            fishData: widget.fishData,
                            fishPrice: widget.fishPrice,
                            qty: int.parse(_qty.text),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                // ElevatedButtonClick(
                //   text: 'Order Now',
                //   fontSize: 20,
                //   onPressed: () {
                //     if (_qty.text.isEmpty) {
                //       Flushbar(
                //         backgroundColor: Colors.red,
                //         message: 'Quantity is required',
                //         icon: const Icon(Icons.info, color: Colors.white),
                //         padding: const EdgeInsets.all(18),
                //         duration: const Duration(seconds: 2),
                //       ).show(context);
                //       return;
                //     }
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => CustomerBill(
                //           id: widget.id,
                //           fishData: widget.fishData,
                //           fishPrice: widget.fishPrice,
                //           qty: int.parse(_qty.text),
                //         ),
                //       ),
                //     );
                //   },
                //   primary: Colors.green,
                // ),
                const SizedBox(height: 30),
                // Show Feedback
                TextButtonClick(
                  text: 'Show Feedback',
                  decoration: TextDecoration.underline,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(customerFeedbacksRoute);
                  },
                  // color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
