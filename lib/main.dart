import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const UTAngleBeamHelper());
}

class UTAngleBeamHelper extends StatelessWidget {
  const UTAngleBeamHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController soundPathController = TextEditingController();
  final TextEditingController probeAngleController = TextEditingController();
  final TextEditingController depthController = TextEditingController();
  final TextEditingController reflectorController = TextEditingController();
  String leg = '1';
  String result = '';

  void calculate() {
    double soundPath = double.parse(soundPathController.text);
    double probeAngle = double.parse(probeAngleController.text) * pi / 180;
    double depth = double.parse(depthController.text);
    double reflector = double.parse(reflectorController.text);

    if (depth < 0) {
      result = 'Error: Depth cannot be negative.';
    } else {
      double surfaceDistance = sin(probeAngle) * soundPath;
      double firstLeg = cos(probeAngle) * soundPath;
      double secondLeg = 2 * depth - (cos(probeAngle) * soundPath);
      double thirdLeg =
          3 * depth - (cos(probeAngle) * soundPath); // added thirdLeg
      double calculatedLeg;

      switch (leg) {
        case '1':
          calculatedLeg = firstLeg;
          break;
        case '2':
          calculatedLeg = secondLeg;
          break;
        case '3':
          calculatedLeg = thirdLeg; // added case for thirdLeg
          break;
        default:
          calculatedLeg = firstLeg;
      }

      double fivePercent = calculatedLeg * 0.05;
      double minRange = calculatedLeg - fivePercent;
      double maxRange = calculatedLeg + fivePercent;

      if (reflector < minRange || reflector > maxRange) {
        result = 'Error: The reflector is not in range.';
      } else {
        result =
        'Surface Distance: $surfaceDistance \nLeg: $leg \nLeg Depth: $calculatedLeg';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UT Angle Beam Helper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: soundPathController,
              decoration: const InputDecoration(
                labelText: 'Sound path [mm]',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: probeAngleController,
              decoration: const InputDecoration(
                labelText: 'Probe angle [°]',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: depthController,
              decoration: const InputDecoration(
                labelText: 'Thickness [mm]',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: reflectorController,
              decoration:
              const InputDecoration(labelText: 'Reflector Depth [mm]'),
              keyboardType: TextInputType.number,
            ), // Here is a comma I added
            DropdownButton<String>(
              value: leg,
              items: <String>['1', '2', '3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Leg $value'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  leg = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: calculate,
              child: const Text('Calculate'),
            ),
            Text(result),
          ],
        ),
      ),
    );
  }
}
