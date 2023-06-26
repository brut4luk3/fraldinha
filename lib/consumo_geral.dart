import 'package:flutter/material.dart';

class ConsumoGeralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo Geral'),
      ),
      body: Center(
        child: Text(
          'Nova Página',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}