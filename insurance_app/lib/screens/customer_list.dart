import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insurance_app/screens/customer.dart';
import 'package:insurance_app/screens/policy_list.dart';
import 'package:insurance_app/models/customer_item.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  void _deleteCustomer(String docId) async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Customer List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 136, 113),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 112, 136, 113),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 112, 136, 113),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value.toLowerCase();
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _searchTerm = _searchController.text.toLowerCase();
                  });
                },
                icon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 112, 136, 113),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final customers = snapshot.data!.docs
                    .map((doc) => CustomerItem.fromFirestore(doc))
                    .where((customer) =>
                        customer.name.toLowerCase().contains(_searchTerm))
                    .toList();
                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final docSnapshot = snapshot.data!.docs[index];
                    final item = customers[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 112, 136, 113),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                      '${item.name} ${item.surname}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return CustomerScreen(
                                                  customer: CustomerItem(
                                                    id: item.id,
                                                    name: item.name,
                                                    surname: item.surname,
                                                    idNumber: item.idNumber,
                                                    birthDate: item.birthDate,
                                                    city: item.city,
                                                    district: item.district,
                                                    phoneNumber: item.phoneNumber,   
                                                    email: item.email,
                                                  ),
                                                  customerId: item.id,
                                                );
                                              }),
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            _deleteCustomer(docSnapshot.id);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Route route = MaterialPageRoute(
                                                builder: (context) {
                                              return const PolicyListScreen();
                                            });
                                            Navigator.push(context, route);
                                          },
                                          icon: const Icon(Icons.list_alt),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${item.email} \n${item.city}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
