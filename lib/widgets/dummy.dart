import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  const Dummy({super.key});
  factory Dummy.instance() => Dummy();
  void printing() {
    print('Function called');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
