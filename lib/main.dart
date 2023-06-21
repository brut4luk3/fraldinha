import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraldinha',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DiaperCalculator(),
    );
  }
}

class DiaperCalculator extends StatefulWidget {
  @override
  _DiaperCalculatorState createState() => _DiaperCalculatorState();
}

class _DiaperCalculatorState extends State<DiaperCalculator> {
  List<int> diaperChanges = [];

  void addDiaperChange() {
    setState(() {
      diaperChanges.add(DateTime.now().millisecondsSinceEpoch);
    });
  }

  int getWeeklyDiaperCount() {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));

    return diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(oneWeekAgo))
        .length;
  }

  int getDailyDiaperCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(today))
        .length;
  }

  double getAverageDiaperChangesPerDay() {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(Duration(days: 30));

    final diaperCount = diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(oneMonthAgo))
        .length;

    final daysElapsed = now.difference(oneMonthAgo).inDays;
    return diaperCount / daysElapsed;
  }

  double getAverageDiaperChangesPerWeek() {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(Duration(days: 365));

    final diaperCount = diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(oneYearAgo))
        .length;

    final weeksElapsed = now.difference(oneYearAgo).inDays / 7;
    return diaperCount / weeksElapsed;
  }

  double getAverageDiaperChangesPerMonth() {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(Duration(days: 365));

    final diaperCount = diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(oneYearAgo))
        .length;

    final monthsElapsed = now.difference(oneYearAgo).inDays / 30;
    return diaperCount / monthsElapsed;
  }

  int getTotalDiaperChangesInCurrentMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return diaperChanges
        .where((timestamp) =>
        DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(startOfMonth))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraldinha'),
      ),
      body: Container(
        color: Colors.red[100], // Fundo vermelho claro
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50),
            CarouselSlider(
              options: CarouselOptions(
                height: 150, // Ajuste a altura dos slides
                aspectRatio: 16 / 9,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
              items: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Fraldas utilizadas nesta semana:',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        getWeeklyDiaperCount().toString(),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas trocadas por dia:',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        getAverageDiaperChangesPerDay().toStringAsFixed(0),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas trocadas por semana:',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        getAverageDiaperChangesPerWeek().toStringAsFixed(0),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas trocadas por mês:',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        getAverageDiaperChangesPerMonth().toStringAsFixed(0),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Total de fraldas trocadas no mês atual:',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        getTotalDiaperChangesInCurrentMonth().toString(),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            Text(
              'Fraldas trocadas hoje:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              getDailyDiaperCount().toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: addDiaperChange,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16), // Ajuste o tamanho do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Ajuste o raio da borda do botão
                ),
              ),
              child: Text(
                'Trocar Fralda',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}