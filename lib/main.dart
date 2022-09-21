import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
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
  bool _isOn = false;
  bool _isNear = false;
  String img = '0';
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _near();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _torchLight,
              child: const Text('Kameramera on/off'),
            ),
            ElevatedButton(
              onPressed: _vibrate,
              child: const Text('Super Saiyajin'),
            ),
            Center(
              child: Text('Gohan está perto ?  $_isNear\n'),
            ),
            Center(
              child: _carregaImagem(img),
            )
            //Text('Está próximo do sensor: $isNear')
          ],
        ),
      ),
    );
  }

  Future<void> _torchLight() async {
    if (!_isOn) {
      _isOn = true;
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        debugPrint('error disabling torch light');
      }
    } else {
      _isOn = false;
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        debugPrint('error enabling torch light');
      }
    }
  }

  Widget _carregaImagem(String tipo) {
    if (tipo == '1') {
      return const Image(image: AssetImage('images/gohan.jpg'));
    } else if (tipo == '2') {
      return const Image(image: AssetImage('images/transformacao.gif'));
    } else if (tipo == '3') {
      return const Image(image: AssetImage('images/transformacaoGohan.jpg'));
    } else if (tipo == '4') {
      return const Image(image: AssetImage('images/cel.jpg'));
    }
    return const Text("Dragon Ball");
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 1500, amplitude: 128);
  }

  Future<void> _near() async {
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        if (_isNear) {
          img = '3';
          _vibrate();
          _torchLight();
        } else {
          img = '4';
          _isOn = false;
          _torchLight();
        }
      });
    });
  }
}
