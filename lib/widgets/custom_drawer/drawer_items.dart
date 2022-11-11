import 'package:sealine_app/constants/routes.dart';

class DrawerItems {
  List boatOwnerItems = [
    'My Boats',
    'Add New Boat',
    'Fish Inventory',
    'Fish Orders',
  ];

  List boatOwnerNavItems = [
    boatHomeRoute,
    addNewBoatRoute,
    fishInventoryRoute,
    fishOrdersRoute,
  ];

  List customerItems = ['Products', 'My Orders', 'Feedbacks'];

  List customerNavItems = [
    customerHomeRoute,
    customerOrdersRoute,
    customerFeedbacksRoute,
  ];

  List inventoryManagerItems = ['INVENTORIES', 'BUYER REQUESTS', 'ASSIGNED LIST'];

  List inventoryManagerNavItems = [
    inventoryManagerHomeRoute,
    buyerReqHomeRoute,
    assignedListHomeRoute,
  ];
}
