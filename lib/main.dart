import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sealine_app/constants/routes.dart';
import 'package:sealine_app/provider/inventory_provider.dart';
import 'package:sealine_app/provider/seller_provider.dart';
import 'package:sealine_app/screens/admin/admin_home.dart';
import 'package:sealine_app/screens/boat_owner/add_new_boat.dart';
import 'package:sealine_app/screens/boat_owner/boat_home.dart';
import 'package:sealine_app/screens/boat_owner/fish_inventory.dart';
import 'package:sealine_app/screens/boat_owner/fish_orders.dart';
import 'package:sealine_app/screens/customer/customer_feedbacks.dart';
import 'package:sealine_app/screens/customer/customer_home.dart';
import 'package:sealine_app/screens/customer/customer_orders.dart';
import 'package:sealine_app/screens/customer/write_feedback.dart';
import 'package:sealine_app/screens/inventory_manager/assigned_list/assigned_list.dart';
import 'package:sealine_app/screens/inventory_manager/buyer_requests/buyer_requests.dart';
import 'package:sealine_app/screens/inventory_manager/inventories/inventory_manager_home.dart';
import 'package:sealine_app/screens/login.dart';
import 'package:sealine_app/screens/register.dart';
import 'package:sealine_app/screens/welcome.dart';
import 'package:sealine_app/utils/check_user.dart';
import 'package:sealine_app/utils/home.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Provider.debugCheckInvalidValueType = null;
  
  runApp(
    MultiProvider(
      providers: [
        Provider<InventoryProvider>(create: (_) => InventoryProvider()),
        Provider<SellerProvider>(create: (_) => SellerProvider()),
      ],
      child: MaterialApp(
        home: const Welcome(),
        routes: {
          homeRoute: (context) => const Home(),
          checkRoute: (context) => const CheckUser(),
          loginRoute: (context) => const Login(),
          registerRoute: (context) => const Register(),
    
          // Boat
          boatHomeRoute: (context) => const BoatHome(),
          addNewBoatRoute: (context) => const AddNewBoat(),
          fishInventoryRoute: (context) => const FishInventory(),
          fishOrdersRoute: (context) => const FishOrders(),
    
          // Customer
          customerHomeRoute: (context) => const CustomerHome(),
          customerOrdersRoute: (context) => const CustomerOrders(),
          customerFeedbacksRoute: (context) => const CustomerFeedback(),
          writeFeedbackRoute: (context) => const WriteFeedback(),
          
          // Inventory Manager
          inventoryManagerHomeRoute: (context) => const InventoryManagerHome(),
          buyerReqHomeRoute: (context) => const BuyerReq(),
          assignedListHomeRoute: (context) => const AssignedList(),

          // Admin
          adminHomeRoute: (context) => const AdminHome(),
        },
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
