import 'package:encryptions_example/test_case.dart';
import 'package:encryptions_example/test_case_config.dart';
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
    return SingleChildScrollView(
      child: Table(
        border: new TableBorder.all(width: 1.0, color: Colors.grey),
        children: rows,
      ),
    );
  }

  TableRow _createRow(Report report) {
    return TableRow(key: ObjectKey(report.name), children: <Widget>[
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(
            "${report.name}",
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
            if (snapshot.hasError) {
              print('got error! ${snapshot.error}');
              return Text("Error:${snapshot.error}");
            }
            print("Done! ${snapshot.data}");
            return _renderTable(snapshot.data.map((report) => _createRow(report)).toList());
          default:
            return Center(
              child: Text("Testing..."),
            );
        }
      },
    );
  }

  Future<List<Report>> test() async {
    List<Report> reports = [];
    for (int i = 0; i < testCases.length; i++) {
      TestCase t = testCases[i];
      bool success;
      try {
        success = await t.execute();
      } catch (err, stack) {
        print(err);
        print(stack);
        success = false;
      }
      reports.add(Report(t.name, success));
    }
    return reports;
  }
}
