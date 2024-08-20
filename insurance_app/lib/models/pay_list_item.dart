import 'package:cloud_firestore/cloud_firestore.dart';


class PayListItem {
  final String name;
  final String surname;
  final String policyNo;
  final String policyValue;

  PayListItem({
    required this.name,
    required this.surname,
    required this.policyNo,
    required this.policyValue,
  });

  factory PayListItem.fromFirestore(DocumentSnapshot doc) {
    return PayListItem(
      name: doc['name'],
      surname: doc['surname'],
      policyNo: doc['policyNo'],
      policyValue: doc['policyValue'],
    );
  }
}

