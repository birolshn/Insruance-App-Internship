import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:insurance_app/screens/home.dart';
import 'package:insurance_app/widgets/card_number_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key, required this.policyNo, required this.policyValue});
  final String policyNo;
  final String policyValue;

  @override
  State<PaymentScreen> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _dropdownValue;
  String? _dropdownValue2;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? policyNo;

  Future<void> _savePaymentDetails(String policyNo, String policyValue) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('payments').add({
        'policyNo': policyNo,
        'policyValue': policyValue,
        'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
        'name': _nameController.text,
        'surname': _surnameController.text,
        'month': _dropdownValue,
        'year': _dropdownValue2,
        'cvv': _cvvController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _showPaymentDialog();
    }
  }

  void _showPaymentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            title: const Text(
              'Payment Details',
              style: TextStyle(
                color: Color.fromARGB(255, 112, 136, 113),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Card Number: ${_cardNumberController.text}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 136, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Name: ${_nameController.text}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 136, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Surname: ${_surnameController.text}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 136, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Policy Number: ${widget.policyNo}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 136, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Policy Value: ${widget.policyValue}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 112, 136, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Route route = MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  );
                  Navigator.push(context, route);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Payment Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 136, 113),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Complete Payment',
                style: TextStyle(
                  color: Color.fromARGB(255, 112, 136, 113),
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                        labelText: 'Credit Card Number',
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
                      maxLength: 19,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormatter(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                        labelText: 'Name',
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
                    child: TextFormField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                        labelText: 'Surname',
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
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 112, 136, 113),
                            width: 2,
                          )),
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        hint: const Text(
                          ' Month',
                          style: TextStyle(
                              color: Color.fromARGB(255, 112, 136, 113),
                              fontSize: 20),
                        ),
                        value: _dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 112, 136, 113),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 112, 136, 113),
                            width: 2,
                          )),
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        hint: const Text(
                          'Year',
                          style: TextStyle(
                              color: Color.fromARGB(255, 112, 136, 113),
                              fontSize: 20),
                        ),
                        value: _dropdownValue2,
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue2 = newValue;
                          });
                        },
                        items: <String>[
                          '2024',
                          '2025',
                          '2026',
                          '2027',
                          '2028',
                          '2029',
                          '2030',
                          '2031',
                          '2032'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 112, 136, 113),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 112, 136, 113),
                        ),
                        labelText: ' CVV',
                      ),
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 136, 113),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _savePaymentDetails(
                          widget.policyNo, widget.policyValue);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 112, 136, 113),
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
