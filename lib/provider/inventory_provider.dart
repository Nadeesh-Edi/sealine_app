import 'package:flutter/material.dart';

class InventoryProvider with ChangeNotifier {
  Map<String, dynamic> inventoryData = {};

  final List<Map<String, dynamic>> sellerList = [];

  void addItemsToList(Map<String, dynamic> dataa) {
    sellerList.add(dataa);
    notifyListeners();
  }

  void removeItemsFromList(int indexx) {
    sellerList.removeAt(indexx);
    notifyListeners();
  }

  void clearItems() {
    inventoryData['sellerList'].clear();
    notifyListeners();
  }

  final List<String> sellerUID = [];

  void addUIDs(String uid) {
    sellerUID.add(uid);
    notifyListeners();
  }

  void clearUIDs() {
    inventoryData['sellerUID'].clear();
    notifyListeners();
  }

  getData({
    String? fishType,
    String? requestedDate,
    String? requestedBy,
    String? customerQty,
    String? customerUID,
    String? customerDocID,
    String? customerAddress,
    String? customerEmail,
    String? customerPhoneNo,
    bool? customerStatus,
    bool? customerAssigned,
    List? sellerList,
    List? sellerUID,
    Map? sellerMap,
  }) {
    if (fishType != null) {
      inventoryData['fishType'] = fishType;
    }

    if (requestedDate != null) {
      inventoryData['requestedDate'] = requestedDate;
    }

    if (requestedBy != null) {
      inventoryData['requestedBy'] = requestedBy;
    }

    if (customerQty != null) {
      inventoryData['customerQty'] = customerQty;
    }

    if (customerUID != null) {
      inventoryData['customerUID'] = customerUID;
    }

    if (customerDocID != null) {
      inventoryData['customerDocID'] = customerDocID;
    }

    if (customerAddress != null) {
      inventoryData['customerAddress'] = customerAddress;
    }

    if (customerEmail != null) {
      inventoryData['customerEmail'] = customerEmail;
    }

    if (customerPhoneNo != null) {
      inventoryData['customePhoneNo'] = customerPhoneNo;
    }

    if (customerStatus != null) {
      inventoryData['customerStatus'] = customerStatus;
    }

    if (customerAssigned != null) {
      inventoryData['customerAssigned'] = customerAssigned;
    }

    if (sellerList != null) {
      inventoryData['sellerList'] = sellerList;
    }

    if (sellerUID != null) {
      inventoryData['sellerUID'] = sellerUID;
    }

    if (sellerMap != null) {
      inventoryData['sellerMap'] = sellerMap;
    }

    notifyListeners();
  }

  void clearAllData() {
    inventoryData.clear();
    notifyListeners();
  }
}
