import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference actor =
      FirebaseFirestore.instance.collection('actor');

  final CollectionReference fish =
      FirebaseFirestore.instance.collection('fish');

  final CollectionReference order =
      FirebaseFirestore.instance.collection('order');

  final CollectionReference boat =
      FirebaseFirestore.instance.collection('boat');

  final CollectionReference inventory =
      FirebaseFirestore.instance.collection('inventory');

  final CollectionReference imInventory =
      FirebaseFirestore.instance.collection('imInventory');

  final CollectionReference feedbacks=
      FirebaseFirestore.instance.collection('feedbacks');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImg({XFile? file, String? reference}) async {
    File filee = File(file!.path);

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(filee);

    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }

  Future<void> addActor({Map<String, dynamic>? data, String? doc}) {
    return actor.doc(doc).set(data);
  }

  Future<void> addOrder({Map<String, dynamic>? data}) {
    return order.doc().set(data);
  }

  Future<void> addBoat({Map<String, dynamic>? data}) {
    return boat.doc().set(data);
  }

  Future<void> addInventory({Map<String, dynamic>? data}) {
    return inventory.doc().set(data);
  }

  Future<void> addIMInventory({Map<String, dynamic>? data}) {
    return imInventory.doc().set(data);
  }

  Future<void> addFeedback({Map<String, dynamic>? data}) {
    return feedbacks.doc().set(data);
  }
}
