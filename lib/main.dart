import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_sample/classes.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
          future: GetIt.I.get<YgoProRepository>().getAllCards(),
          builder: (BuildContext c, AsyncSnapshot<List<YgoCard>> s) {
            if (s.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: s.data!.map((e) => Text(e.name)).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    ));
  }
}
