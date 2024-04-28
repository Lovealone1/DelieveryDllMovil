import 'package:flutter/material.dart';
import 'package:food_delievery/utils/textStyles.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Pantalla de cuenta', style: AppTextStyles.body16Bold,)));
  }
}