import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';


String generatePolicyNo() {
  final Random random = Random();
  String policyNo = '';

  for (int i = 0; i < 6; i++) {
    policyNo += random.nextInt(10).toString();
  }

  return policyNo;
}

Future<String> generateUniquePolicyNo() async {
  String policyNo;
  bool isUnique = false;

  do {
    policyNo = generatePolicyNo();

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('policies')
        .where('policyNo', isEqualTo: policyNo)
        .get();

    if (result.docs.isEmpty) {
      isUnique = true;
    }
  } while (!isUnique);

  return policyNo;
}
