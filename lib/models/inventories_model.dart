// class InventoriesModel {
//   InventoriesModel({
//     this.boatName,
//     this.boatType,
//     this.date,
//     this.expectPrice,
//     this.fishType,
//     this.qty,
//     this.seller,
//     this.status,
//     this.uid,
//   });

//   InventoriesModel.fromJson(Map<String, dynamic> json)
//       : this(
//           boatName: json['fishType']! as String,
//           boatType: json['requestedDate']! as String,
//           date: json['requestedBy']! as String,
//           expectPrice: json['customerQty']! as String,
//           fishType: json['customerUID']! as String,
//           qty: json['qty']! as String,
//           seller: json['seller']! as Map,
//           status: json['status']! as bool,
//           uid: json['uid']! as String,
//         );

//   String? boatName;
//   String? boatType;
//   String? date;
//   String? expectPrice;
//   String? fishType;
//   String? qty;
//   Map? seller;
//   bool? status;
//   String? uid;

//   Map<String, Object?> toJson() {
//     return {
//       'boatName': boatName,
//       'boatType': boatType,
//       'date': date,
//       'expectPrice': expectPrice,
//       'fishType': fishType,
//       'qty': qty,
//       'seller': seller,
//       'status': status,
//       'uid': uid,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Actor {
  final String? name;
  final String? userType;
  final String? contactNo;
  final String? uid;

  Actor({
    this.name,
    this.userType,
    this.contactNo,
    this.uid,
  });

  List<Actor> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return Actor(
        name: dataMap['name'],
        userType: dataMap['userType'],
        contactNo: dataMap['contactNo'],
        uid: dataMap['uid'],
      );
    }).toList();
  }
}
