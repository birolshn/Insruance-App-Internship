import 'package:cloud_firestore/cloud_firestore.dart';


class PolicyListItem {
  final String policyNo;
  final String customerName;
  final String branchCode;
  final double policyValue;
  final String status;
  final String user;


  PolicyListItem({
    required this.policyNo,
    required this.customerName,
    required this.branchCode,
    required this.policyValue,
    required this.status,
    required this.user,
   
  });

  factory PolicyListItem.fromFirestore(DocumentSnapshot doc) {
    return PolicyListItem(
      policyNo: doc['policyNo'],
      customerName: doc['customerName'],
      branchCode: doc['branchCode'],
      policyValue: doc['policyValue'],
      status: doc['status'],
      user: doc['user'],
      
    );
  }
}

