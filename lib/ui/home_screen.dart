import 'package:flutter/material.dart';
import '../services/voice_command_service.dart';
import 'health_status_widget.dart';

class HomeScreen extends StatelessWidget {
  final VoiceCommandService _voiceService = VoiceCommandService();

  void _startListening() {
    _voiceService.listenForCommand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Wheelchair Controller')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HealthStatusWidget(),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _startListening,
            icon: Icon(Icons.mic),
            label: Text('Voice Control'),
          ),
        ],
      ),
    );
  }
}
