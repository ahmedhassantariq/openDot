import 'package:cloud_firestore/cloud_firestore.dart';

class HubModel{
  final String hubID;
  final String hubTitle;
  final String createdBy;
  final Timestamp createdOn;
  final bool isPublic;

  const HubModel({
    required this.hubID,
    required this.hubTitle,
    required this.createdBy,
    required this.createdOn,
    required this.isPublic,
  });

  factory HubModel.fromMap(DocumentSnapshot<Map<String, dynamic>>? documentSnapshot){
    return(
        HubModel(
            hubID: documentSnapshot?.get("hubID"),
            hubTitle: documentSnapshot?.get("hubTitle"),
            createdBy: documentSnapshot?.get("createdBy"),
            createdOn: documentSnapshot?.get("createdOn"),
            isPublic: documentSnapshot?.get("isPublic")
        )
    );
  }
}