import 'package:flutter/material.dart';
import 'package:insurance_app/screens/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:insurance_app/widgets/unique_policy_no.dart';

class HealthPolicyScreen extends StatefulWidget {
  const HealthPolicyScreen({required this.customerName, Key? key})
      : super(key: key);

  final String customerName;

  @override
  _HealthPolicyScreenState createState() => _HealthPolicyScreenState();
}

class _HealthPolicyScreenState extends State<HealthPolicyScreen> {
  int _smokeValue = 0;
  int _sportsValue = 0;
  int _surgeryValue = 0;

  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  double? _policyValue;
  String? policyNo;

  Future<void> _saveHealth() async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.customerName)
          .collection('health')
          .add({
        'smoke': _smokeValue == 0 ? 'Yes' : 'No',
        'sports': _sportsValue == 0 ? 'Yes' : 'No',
        'surgery': _surgeryValue == 0 ? 'Yes' : 'No',
        'medicine': _medicineController.text,
        'age': _ageController.text,
      });

      setState(() {
        _policyValue = int.tryParse(_ageController.text) != null
            ? int.parse(_ageController.text) * 102
            : null;
      });
    } catch (e) {
      print('Error saving health info: $e');
    }
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _ageController.dispose();
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
    final String branchCode = '610';
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
                    'Health',
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
            const Text(
              'Does he/she smoke? ',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: _smokeValue,
                      onChanged: (int? value) {
                        setState(() {
                          _smokeValue = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'No',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _smokeValue,
                      onChanged: (int? value) {
                        setState(() {
                          _smokeValue = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Does he/she do sports? ',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: _sportsValue,
                      onChanged: (int? value) {
                        setState(() {
                          _sportsValue = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'No',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _sportsValue,
                      onChanged: (int? value) {
                        setState(() {
                          _sportsValue = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Did he/she have surgery? ',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: _surgeryValue,
                      onChanged: (int? value) {
                        setState(() {
                          _surgeryValue = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text(
                      'No',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                    ),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _surgeryValue,
                      onChanged: (int? value) {
                        setState(() {
                          _surgeryValue = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Is there any medication he/she use regulary? ',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 112, 136, 113),
                ),
                labelText: 'Medicine',
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
            const SizedBox(height: 20),
            const Text(
              'How old is he/she? ',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 112, 136, 113),
                ),
                labelText: 'Age',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveHealth();
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
