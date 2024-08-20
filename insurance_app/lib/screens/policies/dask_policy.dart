
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insurance_app/screens/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:insurance_app/widgets/unique_policy_no.dart';

class DaskPolicyScreen extends StatefulWidget {
  const DaskPolicyScreen({super.key, required this.customerName});

  final String customerName;

  @override
  State<StatefulWidget> createState() {
    return _DaskPolicyScreenState();
  }
}

class _DaskPolicyScreenState extends State<DaskPolicyScreen> {
  String? _dropdownValue;

  final TextEditingController _uavtCodeController = TextEditingController();
  final TextEditingController _squareMetersController = TextEditingController();
  final TextEditingController _floorsNumberController = TextEditingController();
  final TextEditingController _buildingAgeController = TextEditingController();

  double? _policyValue;
  String? policyNo;

  Future<void> _saveDask() async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.customerName)
          .collection('dask')
          .add({
        'uavtCode': _uavtCodeController.text,
        'squareMeters': _squareMetersController.text,
        'floorsNumber': _floorsNumberController.text,
        'buildingAge': _buildingAgeController.text,
        'buildingType': _dropdownValue,
      });

      setState(() {
        _policyValue = int.tryParse(_squareMetersController.text) != null
            ? int.parse(_squareMetersController.text) * 13
            : null;
      });
    } catch (e) {
      print('Error saving dask info: $e');
    }
  }

  @override
  void dispose() {
    _uavtCodeController.dispose();
    _squareMetersController.dispose();
    _floorsNumberController.dispose();
    _buildingAgeController.dispose();
    super.dispose();
  }

  Future<void> _createPolicy() async {
    policyNo = await generateUniquePolicyNo();
    final DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(widget.customerName)
        .get();
    final String customer = customerSnapshot.id;

    //policyNo = FirebaseFirestore.instance.collection('policies').doc().id;
    final String customerName = customer;
    final String userEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'Unknown User';
    final String status = 'O';
    final String branchCode = '199';
    final double? policyValue = _policyValue;

    final DateTime now = DateTime.now();
    final String issueDate = DateFormat('yyyy-MM-dd').format(now);
    final String startDate = issueDate;
    final String endDate =
        DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 15)));

    await FirebaseFirestore.instance.collection('policies').doc(policyNo).set({
      'policyNo': policyNo,
      'customerName': customerName,
      'status': status,
      'branchCode': branchCode,
      'policyValue': policyValue,
      'user': userEmail,
      'issueDate': issueDate,
      'startDate': startDate,
      'endDate': endDate,
    });
  }

  Future<void> _finalizePolicy() async {
    if (policyNo != null) {
      await FirebaseFirestore.instance
          .collection('policies')
          .doc(policyNo)
          .update({
        'status': 'P',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Dask',
                    style: TextStyle(
                      color: Color.fromARGB(255, 112, 136, 113),
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _uavtCodeController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'UAVT Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 112, 136, 113),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 181, 207, 183),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: _squareMetersController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'Square Meters',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 112, 136, 113),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 181, 207, 183),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _floorsNumberController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'Floors Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 112, 136, 113),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 181, 207, 183),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: _buildingAgeController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'Building Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 112, 136, 113),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 181, 207, 183),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 180,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 112, 136, 113),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(255, 112, 136, 113),
                    width: 2,
                  )),
              child: DropdownButton<String>(
                hint: const Text(
                  'Building Type ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                value: _dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items: <String>['Flat', 'Villa', 'Residence', 'Detached']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                dropdownColor: const Color.fromARGB(255, 112, 136, 113),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _saveDask();
                await _createPolicy();
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 112, 136, 113),
                  width: 1.3,
                ),
              ),
              child: const Text(
                'Get Offer',
                style: TextStyle(
                  color: Color.fromARGB(255, 112, 136, 113),
                  fontSize: 18,
                ),
              ),
            ),
            if (_policyValue != null)
              Card(
                color: const Color.fromARGB(255, 240, 240, 240),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Policy Value',
                        style: TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₺$_policyValue',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                await _finalizePolicy();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      policyNo: policyNo ?? '',
                      policyValue: _policyValue.toString(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 112, 136, 113),
                  width: 1.3,
                ),
              ),
              child: const Text(
                'Finalize Policy',
                style: TextStyle(
                  color: Color.fromARGB(255, 112, 136, 113),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
