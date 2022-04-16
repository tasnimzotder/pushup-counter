import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

export 'homepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  bool _isNear = false;
  bool _currState = false;
  bool _isStart = false;
  String _startBtnMsg = 'Start';
  Color _indicatorColor = Colors.red;

  late StreamSubscription<dynamic> _streamSubscription;

  void updateCounter() {
    if (_isStart == true) {
      if (_isNear) {
        setState(() {
          _indicatorColor = Colors.green;
        });
      } else {
        setState(() {
          _indicatorColor = Colors.red;
        });
      }

      if (_isNear == true && _currState == false) {
        setState(() {
          _counter++;
          _currState = true;
        });
      } else if (_currState = true & _isNear == true) {
        setState(() {
          _currState = false;
        });
      }
    }
  }

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
      });
      updateCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // alert section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              alignment: Alignment.topRight,
              // height: 50.0,
              // color: Colors.red,
              child: CircleAvatar(
                // backgroundColor: _indicatorColors['red'],
                backgroundColor: _indicatorColor,
                radius: 20.0,
              ),
            ),

            // main body (counter and action buttons)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '$_counter',
                      style: const TextStyle(
                        fontSize: 108.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          _startBtnMsg,
                          style: const TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        color: Colors.blueGrey,
                        onPressed: () {
                          setState(() {
                            _isStart = !_isStart;
                            _startBtnMsg = _isStart ? 'Pause' : 'Start';
                          });
                        },
                      ),
                      RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        color: Colors.blueGrey,
                        onPressed: () {
                          setState(() {
                            _counter = 0;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            // bottom section (about)
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              alignment: Alignment.topRight,
              height: 70.0,
              // color: Colors.yellow,
              child: IconButton(
                icon: const Icon(Icons.info),
                iconSize: 32.0,
                color: Colors.blueGrey,
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Push-up Counter',
                    applicationVersion: '0.0.1-beta-1',
                    // applicationIcon: const Icon(Icons.info),
                    applicationLegalese: '© Tasnim Zotder | 2022',
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 36.0),
                        child: const Text(
                          "To use this app, place the phone under your chest and press the start button.\n",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
