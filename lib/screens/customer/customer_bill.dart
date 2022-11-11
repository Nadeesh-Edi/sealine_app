import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sealine_app/screens/customer/customer_place_order.dart';
import 'package:sealine_app/widgets/buttons.dart';
import 'package:sealine_app/widgets/custom_drawer/customer_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/logo.dart';

class CustomerBill extends StatefulWidget {
  final String id;
  final Map<String, dynamic> fishData;
  final String fishPrice;
  final int qty;

  const CustomerBill({
    Key? key,
    required this.id,
    required this.fishData,
    required this.fishPrice,
    required this.qty,
  }) : super(key: key);

  @override
  State<CustomerBill> createState() => _CustomerBillState();
}

class _CustomerBillState extends State<CustomerBill> {
  @override
  Widget build(BuildContext context) {
    final DrawerItems drawerItems = DrawerItems();

    int total = widget.fishData['fishPrice'] * widget.qty;

    String totalPrice = NumberFormat('###,###').format(total);

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
          'Bill',
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
        drawerItems: drawerItems.customerItems,
        routeList: drawerItems.customerNavItems,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
            child: Column(
              children: [
                // Image
                Container(
                  height: 250,
                  width: 250,
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
                // Product Title
                Text(
                  widget.fishData['fishName'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                // Product
                OnlyTextFields(
                  text: 'Product',
                  field: widget.fishData['fishName'],
                ),
                // Price
                OnlyTextFields(text: 'Price', field: widget.fishPrice),
                // Qty
                OnlyTextFields(text: 'Qty', field: widget.qty.toString()),
                // Total
                OnlyTextFields(text: 'Total', field: totalPrice.toString()),
                const SizedBox(height: 30),
                // Proceed Order
                CustomerFormattedButton(
                  text: 'Proceed Order',
                  color: const Color.fromARGB(255, 0, 51, 128),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CustomerPlaceOrder(
                          id: widget.id,
                          fishData: widget.fishData,
                          fishPrice: widget.fishPrice,
                          qty: widget.qty,
                          totalPrice: totalPrice,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnlyTextFields extends StatelessWidget {
  const OnlyTextFields({
    Key? key,
    required this.text,
    required this.field,
  }) : super(key: key);

  final String text;
  final String field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text :',
            style: const TextStyle(fontSize: 17),
          ),
          Text(
            field,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
