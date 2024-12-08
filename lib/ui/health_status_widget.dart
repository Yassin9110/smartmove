import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class HealthStatusWidget extends StatelessWidget {
  final SensorData sensorData = SensorData(heartRate: 72, temperature: 98.6); // Example data

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85, // Fills 85% of screen width
              height: MediaQuery.of(context).size.height * 0.6, // Fills 60% of screen height
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.favorite, color: Colors.redAccent, size: 30),
                      title: Text(
                        'Heart Rate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${sensorData.heartRate} BPM',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    ListTile(
                      leading: Icon(Icons.thermostat, color: Colors.orangeAccent, size: 30),
                      title: Text(
                        'Temperature',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${sensorData.temperature}°F',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
