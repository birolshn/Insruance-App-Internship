import 'package:flutter/material.dart';
import 'package:insurance_app/screens/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:insurance_app/widgets/unique_policy_no.dart';

class CascoPolicyScreen extends StatefulWidget {
  const CascoPolicyScreen({super.key, required this.customerName});

  final String customerName;

  @override
  State<CascoPolicyScreen> createState() {
    return _CascoPolicyScreenState();
  }
}

class _CascoPolicyScreenState extends State<CascoPolicyScreen> {
  String? _dropdownValue1;
  String? _dropdownValue2;
  int? _dropdownValue3;

  Map<String, List<String>> _carModelMap = {};
  double? _price;
  double? _policyValue;
  String? policyNo;

  List<String> _cars = [];
  List<String> _models = [];
  List<int> _modelYears = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('vehicles').get();

    final Set<String> fetchedCars = {};
    final Set<int> fetchedModelYears = {};
    final Map<String, List<String>> carModelMap = {};

    for (var doc in snapshot.docs) {
      String car = doc['car'] as String;
      String model = doc['model'] as String;
      int modelYear = doc['modelYear'] as int;

      fetchedCars.add(car);
      fetchedModelYears.add(modelYear);

      if (carModelMap.containsKey(car)) {
        carModelMap[car]!.add(model);
      } else {
        carModelMap[car] = [model];
      }
    }

    setState(() {
      _cars = fetchedCars.toList();
      _carModelMap = carModelMap;
      _modelYears = fetchedModelYears.toList();
    });
  }

  void _updateModels(String selectedCar) {
    setState(() {
      _models = _carModelMap[selectedCar] ?? [];
      _dropdownValue2 = null;
    });
  }

  Future<void> _getPrice() async {
    if (_dropdownValue1 != null &&
        _dropdownValue2 != null &&
        _dropdownValue3 != null) {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('car', isEqualTo: _dropdownValue1)
          .where('model', isEqualTo: _dropdownValue2)
          .where('modelYear', isEqualTo: _dropdownValue3)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        setState(() {
          _price = doc['price'].toDouble();
          _policyValue = _price! * 0.01027;
        });
      }
    }
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
    final String branchCode = '340';
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
                    'Casco',
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
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'City Code',
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
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                      ),
                      labelText: 'Plate Code',
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 112, 136, 113),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 112, 136, 113),
                          width: 1,
                        )),
                    child: DropdownButton<String>(
                      hint: const Text(
                        'Car',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      value: _dropdownValue1,
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue1 = newValue;
                          _updateModels(newValue!);
                        });
                      },
                      items: _cars.map((String car) {
                        return DropdownMenuItem<String>(
                          value: car,
                          child: Text(
                            car,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(255, 112, 136, 113),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 112, 136, 113),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 112, 136, 113),
                          width: 1,
                        )),
                    child: DropdownButton<String>(
                      hint: const Text(
                        'Model',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      value: _dropdownValue2,
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue2 = newValue;
                        });
                      },
                      items: _models.map((String model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(
                            model,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(255, 112, 136, 113),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 112, 136, 113),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 112, 136, 113),
                          width: 1,
                        )),
                    child: DropdownButton<int>(
                      hint: const Text(
                        'Year',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      value: _dropdownValue3,
                      onChanged: (int? newValue) {
                        setState(() {
                          _dropdownValue3 = newValue;
                        });
                      },
                      items: _modelYears.map((int modelYear) {
                        return DropdownMenuItem<int>(
                          value: modelYear,
                          child: Text(
                            modelYear.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(255, 112, 136, 113),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _getPrice();
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
            if (_price != null && _policyValue != null)
              Card(
                color: const Color.fromARGB(255, 240, 240, 240),
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Car: $_dropdownValue1',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                      ),
                      Text(
                        'Model: $_dropdownValue2',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                      ),
                      Text(
                        'Year: $_dropdownValue3',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Price: ₺${_price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                      ),
                      Text(
                        'Policy Value: ₺${_policyValue!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 112, 136, 113),
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
