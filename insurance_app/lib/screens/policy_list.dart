import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insurance_app/models/policy_list_item.dart';

class PolicyListScreen extends StatefulWidget {
  const PolicyListScreen({super.key});

  @override
  State<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends State<PolicyListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  //double? policyValue;
  //String? policyNo;

  void _deletePolicy(String docId) async {
    await FirebaseFirestore.instance.collection('policies').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Policy List',
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
              stream:
                  FirebaseFirestore.instance.collection('policies').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final policies = snapshot.data!.docs
                    .map((doc) => PolicyListItem.fromFirestore(doc))
                    .where((policy) =>
                        policy.customerName.toLowerCase().contains(_searchTerm))
                    .toList();
                return ListView.builder(
                  itemCount: policies.length,
                  itemBuilder: (context, index) {
                    final docSnapshot = snapshot.data!.docs[index];
                    final item = policies[index];

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
                                      '${item.customerName} ',
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
                                            _deletePolicy(docSnapshot.id);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                        
                                      ],
                                    ),
                                    subtitle: Text(
                                      'Branch Code: ${item.branchCode} \nPolicy Value: ${item.policyValue} \nStatus: ${item.status} \nInsurer: ${item.user}',
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
