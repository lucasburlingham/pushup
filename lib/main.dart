import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

void main() {
  runApp(const Pushup());
}
// https://stackoverflow.com/a/50382196

class Pushup extends StatelessWidget {
  const Pushup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushup',
      theme: ThemeData(
        // https://stackoverflow.com/a/70507145
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF5FD1AC),
        ),
      ),
      home: const CountingPage(title: 'Pushup: Don\'t be weak!'),
    );
  }
}

class CountingPage extends StatefulWidget {
  const CountingPage({super.key, required this.title});

  final String title;

  @override
  State<CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {
  double _counter = -.5;
  bool _isNear = false;

  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        _incrementCounter();
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter = _counter + .5;
    });
  }

  void _clearCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // void _openPage() {
  //   const url = "https://lucasburlingham.me/";
  //   launchUrl(Uri.parse(url));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Number of Pushups:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              'Place your device on the ground below you, and start pushing!',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearCounter,
        tooltip: 'Clear Number',
        backgroundColor: const Color(0xFF5FD1AC),
        child: const Icon(
          Icons.delete,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
