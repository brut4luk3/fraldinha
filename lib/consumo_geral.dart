import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'month_data.dart';

class ConsumoGeralPage extends StatelessWidget {
  final List<MonthData> monthDataList;

  ConsumoGeralPage(this.monthDataList);

  @override
  Widget build(BuildContext context) {
    List<MonthData> completeMonthDataList = _generateMonthDataList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo Geral'),
      ),
      body: Container(
        color: Colors.red[200],
        padding: EdgeInsets.all(16),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 400,
            viewportFraction: 0.9,
            enableInfiniteScroll: false,
          ),
          items: completeMonthDataList.map((monthData) {
            return Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    monthData.monthName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: Container(
                      child: _buildChart(monthData.diaperChanges),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<MonthData> _generateMonthDataList() {
    List<MonthData> completeMonthDataList = [];

    for (int month = 1; month <= 12; month++) {
      String monthName = DateFormat.MMMM().format(DateTime(2023, month));
      List<int> diaperChanges = monthDataList
          .firstWhere((data) => data.monthName == monthName, orElse: () => MonthData(monthName, []))
          .diaperChanges;

      completeMonthDataList.add(MonthData(monthName, diaperChanges));
    }

    return completeMonthDataList;
  }

  Widget _buildChart(List<int> diaperChanges) {
    List<charts.Series<TimeSeriesData, DateTime>> seriesList = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Fraldas',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: _generateChartData(diaperChanges),
      ),
    ];

    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  List<TimeSeriesData> _generateChartData(List<int> diaperChanges) {
    List<TimeSeriesData> chartData = [];
    Map<DateTime, int> dailyCounts = {};

    for (int timestamp in diaperChanges) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (!dailyCounts.containsKey(date)) {
        dailyCounts[date] = 0;
      }

      dailyCounts[date] = dailyCounts[date]! + 1;
    }

    dailyCounts.forEach((date, count) {
      chartData.add(TimeSeriesData(date, count));
    });

    return chartData;
  }
}

class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}