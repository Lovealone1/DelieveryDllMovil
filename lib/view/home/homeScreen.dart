import 'package:flutter/material.dart';
import 'package:food_delievery/utils/textStyles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Pantalla de inicio', style: AppTextStyles.body16Bold,)));
  }
}