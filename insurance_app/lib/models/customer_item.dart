import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerItem {
  final String id;
  final String name;
  final String surname;
  final String idNumber;
  final String birthDate;
  final String city;
  final String district;
  final String phoneNumber;
  final String email;

  CustomerItem({
    required this.id,
    required this.name,
    required this.surname,
    required this.idNumber,
    required this.birthDate,
    required this.city,
    required this.district,
    required this.phoneNumber,
    required this.email,
  });

  factory CustomerItem.fromFirestore(DocumentSnapshot doc) {
    return CustomerItem(
      id: doc.id,
      name: doc['name'],
      surname: doc['surname'],
      idNumber: doc['idNumber'],
      birthDate: doc['birthDate'],
      city: doc['city'],
      district: doc['district'],
      phoneNumber: doc['phoneNumber'],
      email: doc['email'],
    );
  }
}
