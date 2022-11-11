class AssignedModel {
  AssignedModel({
    this.fishType,
    this.requestedDate,
    this.requestedBy,
    this.customerQty,
    this.customerUID,
    this.customerDocID,
    this.customerAddress,
    this.customerEmail,
    this.customerPhoneNo,
    this.customerStatus,
    this.customerAssigned,
  });

  AssignedModel.fromJson(Map<String, Object?> json)
      : this(
          fishType: json['fishType']! as String,
          requestedDate: json['requestedDate']! as String,
          requestedBy: json['requestedBy']! as String,
          customerQty: json['customerQty']! as String,
          customerUID: json['customerUID']! as String,
          customerDocID: json['customerDocID']! as String,
          customerAddress: json['customerAddress']! as String,
          customerEmail: json['customerEmail']! as String,
          customerPhoneNo: json['customerPhoneNo']! as String,
          customerStatus: json['customerStatus']! as bool,
          customerAssigned: json['customerAssigned']! as bool,
        );

  String? fishType;
  String? requestedDate;
  String? requestedBy;
  String? customerQty;
  String? customerUID;
  String? customerDocID;
  String? customerAddress;
  String? customerEmail;
  String? customerPhoneNo;
  bool? customerStatus;
  bool? customerAssigned;

  Map<String, Object?> toJson() {
    return {
      'fishType': fishType,
      'requestedDate': requestedDate,
      'requestedBy': requestedBy,
      'customerQty': customerQty,
      'customerUID': customerUID,
      'customerDocID': customerDocID,
      'customerAddress': customerAddress,
      'customerEmail': customerEmail,
      'customerPhoneNo': customerPhoneNo,
      'customerStatus': customerStatus,
      'customerAssigned': customerAssigned,
    };
  }
}
