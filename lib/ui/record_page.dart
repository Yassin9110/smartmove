import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderPlayerPage extends StatefulWidget {
  @override
  _AudioRecorderPlayerPageState createState() =>
      _AudioRecorderPlayerPageState();
}

class _AudioRecorderPlayerPageState extends State<AudioRecorderPlayerPage> {
  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;
  bool isRecording = false;
  late String _recordingPath;  // Path to save the recording
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initializeRecorderAndPlayer();
  }

  // Initialize recorder and player
  Future<void> _initializeRecorderAndPlayer() async {
    await Permission.microphone.request();
    await Permission.storage.request();  // If you need to store the audio file
    await _recorder.openRecorder();
    await _player.openPlayer();
  }

  // Start recording and save to variable
  Future<void> _startRecording() async {
    if (!isRecording) {
      String path = await _getTempPath();
      await _recorder.startRecorder(
        toFile: path,  // Save the recording to the temp file
        codec: Codec.mp3,  // Save as MP3
      );
      setState(() {
        isRecording = true;
        _recordingPath = path;  // Save the path of the recorded file
      });
    }
  }

  // Stop recording
  Future<void> _stopRecording() async {
    if (isRecording) {
      await _recorder.stopRecorder();
      setState(() {
        isRecording = false;
      });
    }
  }

  // Play the recorded audio from the variable
  Future<void> _playRecording() async {
    if (_recordingPath != null && !isPlaying) {
      await _player.startPlayer(
        fromURI: _recordingPath,  // Play from the saved path
        codec: Codec.mp3,
        whenFinished: () {
          setState(() {
            isPlaying = false;
          });
        },
      );
      setState(() {
        isPlaying = true;
      });
    }
  }

  // Get a temporary path to save the audio file
  Future<String> _getTempPath() async {
    // You can use the path_provider package to get a temporary directory
    // Here we'll use a simple hardcoded path for simplicity
    return '/storage/emulated/0/Download/temp_audio.mp3';  // Example path
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Recorder & Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startRecording,
              child: Text(isRecording ? 'Recording...' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopRecording,
              child: Text('Stop Recording'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playRecording,
              child: Text(isPlaying ? 'Playing...' : 'Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
