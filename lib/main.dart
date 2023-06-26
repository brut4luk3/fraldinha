import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consumo_geral.dart';
import 'month_data.dart';

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

  @override
  void initState() {
    super.initState();
    loadDiaperChanges(); // Carrega os registros de fraldas ao iniciar o aplicativo
  }

  void addDiaperChange() {
    setState(() {
      diaperChanges.add(DateTime.now().millisecondsSinceEpoch);
      saveDiaperChanges(); // Salva os registros de fraldas após cada adição
    });
  }

  void loadDiaperChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int>? savedDiaperChanges = prefs.getStringList('diaperChanges')?.map(int.parse).toList();
    if (savedDiaperChanges != null) {
      setState(() {
        diaperChanges = savedDiaperChanges;
      });
    }
  }

  void saveDiaperChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = diaperChanges.map((timestamp) => timestamp.toString()).toList();
    prefs.setStringList('diaperChanges', stringList);
  }

  void showConsumoGeralPage() {
    List<MonthData> monthDataList = createMonthDataList();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConsumoGeralPage(monthDataList)),
    );
  }

  List<MonthData> createMonthDataList() {
    Map<String, List<int>> monthDataMap = {};

    for (int timestamp in diaperChanges) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String monthName = DateFormat('MMMM').format(dateTime);

      if (!monthDataMap.containsKey(monthName)) {
        monthDataMap[monthName] = [];
      }

      monthDataMap[monthName]!.add(timestamp);
    }

    List<MonthData> monthDataList = [];

    monthDataMap.forEach((monthName, diaperChanges) {
      monthDataList.add(MonthData(monthName, diaperChanges));
    });

    return monthDataList;
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayDiaperChanges = diaperChanges
        .where((timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp).isAfter(today))
        .toList();

    final lastDiaperChangeFormatted = todayDiaperChanges.isNotEmpty
        ? DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(todayDiaperChanges.last).subtract(Duration(hours: 3)))
        : '--:--';

    return Scaffold(
      appBar: AppBar(
        title: Text('Fraldinha'),
      ),
      body: Container(
        color: Colors.red[200],
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
                viewportFraction: 0.9, // Define a fração do espaço horizontal ocupada por cada slide
              ),
              items: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Fraldas p/ semana',
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
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas p/ dia',
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
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas p/ semana',
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
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Média de fraldas p/ mês',
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
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Ajuste a distância entre os textos
                    children: <Widget>[
                      Text(
                        'Total de fraldas no mês atual',
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
            SizedBox(height: 50),
            Text(
              'Última troca em',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              lastDiaperChangeFormatted,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Fraldas trocadas hoje',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              getDailyDiaperCount().toString(),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: showConsumoGeralPage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Consumo Geral',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: addDiaperChange,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16), // Ajuste o tamanho do botão
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10) // Ajuste o raio da borda do botão
                    )
                ),
                child: Text(
                  'Trocar Fralda',
                  style: TextStyle(fontSize: 30),
                )
            )
          ],
        ),
      ),
    );
  }
}