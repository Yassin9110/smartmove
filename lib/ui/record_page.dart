import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/voice_command_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AudioRecorderPlayerPage extends StatefulWidget {
  @override
  _AudioRecorderPlayerPageState createState() =>
      _AudioRecorderPlayerPageState();
}

class _AudioRecorderPlayerPageState extends State<AudioRecorderPlayerPage> {
  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;

  late VoiceCommandService _voiceCommandService;
  bool isRecording = false;
  late String _recordingPath;
  late String _selectedFilePath;

  String _response = "";
  late File audio;// Store API response
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _voiceCommandService = VoiceCommandService();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder.openRecorder();
    await _player.openPlayer();

  }

  Future<void> _startRecording() async {
    if (!isRecording) {
      _recordingPath = await _getTempPath();
      _selectedFilePath = _recordingPath ;
      await _recorder.startRecorder(toFile: _recordingPath);
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (isRecording) {
      await _recorder.stopRecorder();
      setState(() {
        isRecording = false;
      });
    }
  }


  Future<void> _playAudio(String filePath) async {
    await _player.startPlayer(
      fromURI: filePath,
      codec: Codec.defaultCodec,
      whenFinished: () => setState(() {}),
    );
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path!;
      });
    }
  }


  Future<String> _getTempPath() async {
    return '/storage/emulated/0/Download/temp_audio.wav'; // Example path
  }

  Future<void> _sendAudioToApi(String filePath) async {
    setState(() {
      isProcessing = true;
      _response = "Processing...";
    });

    var result = await _voiceCommandService.sendAudioToApi(filePath);

    setState(() {
      isProcessing = false;
      if (result.containsKey("error")) {
        _response = result["error"];
      } else {
        _response = result["response"];
        audio = result["audio"];


      }
    });
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
      appBar: AppBar(title: Text('Audio Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isRecording ? _stopRecording : _startRecording,
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select .wav File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if ((_selectedFilePath != null && _selectedFilePath!.isNotEmpty) ||
                    _recordingPath.isNotEmpty) {
                  _playAudio(_selectedFilePath ?? _recordingPath);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No audio file selected or recorded.')),
                  );
                }
              },
              child: Text('Play Selected/Recorded Audio'),
            ),








            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if ((audio != null)) {
                  _playAudio(audio.path);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No audio file selected or recorded.')),
                  );
                }
              },
              child: Text('Play response'),
            ),








































            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () => _sendAudioToApi(_selectedFilePath ?? _recordingPath),
              child: Text(isProcessing ? 'Processing...' : 'Send to API'),
            ),
            SizedBox(height: 20),
            Text(
              _response,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
