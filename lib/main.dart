import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _torchLight,
              child: const Text('Turn on/off light'),
            ),
            ElevatedButton(
              onPressed: _vibrate,
              child: const Text('Vibrate'),
            )
            //Text('Está próximo do sensor: $isNear')
          ],
        ),
      ),
    );
  }

  Future<void> _torchLight() async {
    if (!isOn) {
      isOn = true;
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        print('error disabling torch light');
      }
    } else {
      isOn = false;
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        print('error enabling torch light');
      }
    }
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 1000, amplitude: 128);
  }
}
