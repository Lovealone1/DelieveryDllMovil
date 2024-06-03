import 'package:covefood_users/utils/textStyles.dart';
import 'package:flutter/material.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text(
      'Pantalla de tiendas',
      style: AppTextStyles.body16Bold,
    )));
  }
}