import 'package:flutter/material.dart';
import 'package:insurance_app/screens/customer_list.dart';
import 'package:insurance_app/widgets/custom_date_field.dart';
import 'package:insurance_app/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:insurance_app/models/customer_item.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final maskFormatter = MaskTextInputFormatter(
  mask: '(###) ###-####',
  filter: {"#": RegExp(r'[0-9]')},
);

final formatter = DateFormat.yMd();
final uuid = Uuid();

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key, this.customer, this.customerId})
      : super(key: key);

  final CustomerItem? customer;
  final String? customerId;

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _idNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _surnameController =
        TextEditingController(text: widget.customer?.surname ?? '');
    _idNumberController =
        TextEditingController(text: widget.customer?.idNumber ?? '');
    _birthDateController =
        TextEditingController(text: widget.customer?.birthDate ?? '');
    _cityController = TextEditingController(text: widget.customer?.city ?? '');
    _districtController =
        TextEditingController(text: widget.customer?.district ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.customer?.phoneNumber ?? '');
    _emailController =
        TextEditingController(text: widget.customer?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _birthDateController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final firestore = FirebaseFirestore.instance;

      final customerData = {
        'name': _nameController.text,
        'surname': _surnameController.text,
        'idNumber': _idNumberController.text,
        'birthDate': _birthDateController.text,
        'city': _cityController.text,
        'district': _districtController.text,
        'phoneNumber': _phoneNumberController.text,
        'email': _emailController.text,
      };

      if (widget.customerId == null) {
        String uniqueId = uuid.v4();
        await firestore.collection('customers').doc(uniqueId).set(customerData);
        Route route = MaterialPageRoute(builder: (context) {
          return const CustomerListScreen();
        });
        Navigator.push(context, route);
      } else {
        await firestore
            .collection('customers')
            .doc(widget.customerId)
            .update(customerData);
        Route route = MaterialPageRoute(builder: (context) {
          return const CustomerListScreen();
        });
        Navigator.push(context, route);
      }

      //_formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.customer == null ? 'New Customer' : 'Edit Customer',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 136, 113),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                text: 'Name',
                controller: _nameController,
                maxLength: 30,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _nameController.text = value!;
                },
              ),
              CustomTextFormField(
                text: 'Surname',
                controller: _surnameController,
                maxLength: 30,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _surnameController.text = value!;
                },
              ),
              CustomTextFormField(
                text: 'TR Identification Number',
                controller: _idNumberController,
                maxLength: 11,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Must be a valid, positive number';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _idNumberController.text = value!;
                },
              ),
              CustomDateFormField(
                controller: _birthDateController,
                onSaved: (value) {
                  return _birthDateController.text = value!;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextFormField(
                text: 'City',
                controller: _cityController,
                maxLength: 20,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 20) {
                    return 'Must be between 1 and 20 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _cityController.text = value!;
                },
              ),
              CustomTextFormField(
                text: 'District',
                controller: _districtController,
                maxLength: 20,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 20) {
                    return 'Must be between 1 and 20 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _districtController.text = value!;
                },
              ),
              CustomTextFormField(
                text: 'Phone Number',
                controller: _phoneNumberController,
                maxLength: 14,
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatter],
                validator: (value) {
                  final unmaskedText = maskFormatter.getUnmaskedText();
                  if (unmaskedText.isEmpty ||
                      unmaskedText.length != 10
                      ) {
                    return 'Must be a valid, positive number';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _phoneNumberController.text =
                      maskFormatter.getUnmaskedText();
                },
              ),
              CustomTextFormField(
                text: 'E-mail',
                controller: _emailController,
                maxLength: 50,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Must be a valid e-mail address';
                  }
                  return null;
                },
                onSaved: (value) {
                  return _emailController.text = value!;
                },
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
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 112, 136, 113),
                    ),
                    child: Text(
                      widget.customer == null
                          ? 'Add Customer'
                          : 'Update Customer',
                      style: const TextStyle(
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
