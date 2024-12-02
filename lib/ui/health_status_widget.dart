import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class HealthStatusWidget extends StatelessWidget {
  final SensorData sensorData = SensorData(heartRate: 72, temperature: 98.6); // Example data

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Heart Rate: ${sensorData.heartRate} BPM'),
          ),
          ListTile(
            title: Text('Temperature: ${sensorData.temperature}°F'),
          ),
        ],
      ),
    );
  }
}
