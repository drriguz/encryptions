import 'package:encryptions_example/platform_test.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Report>> reports;

  @override
  void initState() {
    super.initState();
    reports = test();
  }

  static const headerStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const successStyle = TextStyle(fontSize: 16, color: Colors.green);
  static const errorStyle = TextStyle(fontSize: 16, color: Colors.red);
  static const padding = EdgeInsets.all(5.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
          child: _renderReport(),
        ),
      ),
    );
  }

  Widget _renderTable(List<TableRow> rows) {
    return Table(
      border: new TableBorder.all(width: 1.0, color: Colors.grey),
      children: <TableRow>[
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: padding,
              child: Text('Test', style: headerStyle),
            ),
          ),
          TableCell(
            child: Padding(
              padding: padding,
              child: Text('Result', style: headerStyle),
            ),
          ),
        ]),
        ...rows
      ],
    );
  }

  TableRow _createRow(Report report) {
    return TableRow(children: <Widget>[
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(report.name),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(
            "${report.success}",
            style: report.success ? successStyle : errorStyle,
          ),
        ),
      ),
    ]);
  }

  Widget _renderReport() {
    return FutureBuilder<List<Report>>(
      future: reports,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _renderTable(
                snapshot.data.map((report) => _createRow(report)).toList());
          default:
            return Text("Testing...");
        }
      },
    );
  }

  Future<List<Report>> test() async {
    List<Report> reports = [];
    tests.forEach((t) async {
      bool success;
      try {
        success = await t.executor();
      } catch (err, stack) {
        print(err);
        print(stack);
        success = false;
      }
      reports.add(Report(t.name, success));
    });
    return reports;
  }
}
