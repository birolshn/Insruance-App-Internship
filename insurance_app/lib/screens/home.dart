import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insurance_app/screens/auth.dart';
import 'package:insurance_app/screens/customer.dart';
import 'package:insurance_app/screens/customer_list.dart';
import 'package:insurance_app/screens/policy.dart';
import 'package:insurance_app/screens/policy_list.dart';
import 'package:insurance_app/widgets/custom_button.dart';
import 'package:insurance_app/screens/pay_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 136, 113),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    icon: Icons.person,
                    text: 'New Customer',
                    backgroundColor: const Color.fromARGB(255, 182, 199, 170),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) {
                        return const CustomerScreen();
                      });
                      Navigator.push(context, route);
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: CustomButton(
                    icon: Icons.policy,
                    text: 'New Policy',
                    backgroundColor: const Color.fromARGB(255, 182, 199, 170),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) {
                        return const PolicyScreen();
                      });
                      Navigator.push(context, route);
                    },
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
                  child: CustomButton(
                    icon: Icons.person,
                    text: 'Customer List',
                    backgroundColor: const Color.fromARGB(255, 182, 199, 170),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) {
                        return const CustomerListScreen();
                      });
                      Navigator.push(context, route);
                    },
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
                  child: CustomButton(
                    icon: Icons.policy,
                    text: 'Policy List',
                    backgroundColor: const Color.fromARGB(255, 182, 199, 170),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) {
                        return const PolicyListScreen();
                      });
                      Navigator.push(context, route);
                    },
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
                  child: CustomButton(
                    icon: Icons.payment,
                    text: 'Pay List',
                    backgroundColor: const Color.fromARGB(255, 182, 199, 170),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) {
                        return const PayListScreen();
                      });
                      Navigator.push(context, route);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
