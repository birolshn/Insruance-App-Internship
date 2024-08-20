import 'package:flutter/material.dart';
import 'package:insurance_app/screens/policies/casco_policy.dart';
import 'package:insurance_app/screens/policies/dask_policy.dart';
import 'package:insurance_app/screens/policies/health_policy.dart';
import 'package:insurance_app/screens/policies/traffic_policy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String? _selectedValue1;
  String? _selectedValue2;

  final List<String> _options = ['Traffic', 'Casco', 'Health', 'Dask'];
  List<String> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('customers').get();
    final List<String> fetchedCustomers = snapshot.docs.map((doc) {
      return doc['name'] as String;
    }).toList();

    setState(() {
      _customers = fetchedCustomers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'New Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 136, 113),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 112, 136, 113),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 112, 136, 113),
                              width: 2,
                            )),
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Policies',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          value: _selectedValue1,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue1 = newValue;
                              _selectedValue2 = null;
                            });
                          },
                          items: _options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor:
                              const Color.fromARGB(255, 112, 136, 113),
                          isExpanded: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 112, 136, 113),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 112, 136, 113),
                              width: 2,
                            )),
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Customer',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          value: _selectedValue2,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue2 = newValue;
                            });
                          },
                          items: _customers.map((String customer) {
                            return DropdownMenuItem<String>(
                              value: customer,
                              child: Text(
                                customer,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor:
                              const Color.fromARGB(255, 112, 136, 113),
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color.fromARGB(255, 112, 136, 113),
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_selectedValue1 != null) _buildForm(_selectedValue1!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String selectedValue) {
    switch (selectedValue) {
      case 'Traffic':
        return TrafficPolicyScreen(customerName: _selectedValue2 ?? '');
      case 'Casco':
        return CascoPolicyScreen(customerName: _selectedValue2 ?? '');
      case 'Health':
        return HealthPolicyScreen(customerName: _selectedValue2 ?? '');
      case 'Dask':
        return DaskPolicyScreen(customerName: _selectedValue2 ?? '');
      default:
        return Container();
    }
  }
}
