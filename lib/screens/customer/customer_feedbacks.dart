import 'package:flutter/material.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/widgets/buttons.dart';
import 'package:sealine_app/widgets/custom_drawer/customer_drawer.dart';
import 'package:sealine_app/widgets/custom_drawer/drawer_items.dart';
import 'package:sealine_app/widgets/customer/feedbacks/feedbacks_stream.dart';
import 'package:sealine_app/widgets/logo.dart';

class CustomerFeedback extends StatelessWidget {
  const CustomerFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerItems drawerItems = DrawerItems();

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
          'Feedbacks',
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Write a feedback
                TextButtonClick(
                  text: 'Write a feedback',
                  color: const Color.fromARGB(255, 0, 51, 128),
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  onPressed: () {
                    Navigator.of(context).pushNamed(writeFeedbackRoute);
                  },
                ),
                const SizedBox(height: 20),
                const FeedbacksStream(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
