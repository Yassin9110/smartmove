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
  String _recordingPath = '';
  late String _selectedFilePath;

  String _response = "";
  late File audio;// Store API response
  bool isProcessing = false;

  List<String> _responseWords = [];
  List<bool> _isWordBright = [];
  int _currentWordIndex = 0;
  bool isPlaying = false;


  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _voiceCommandService = VoiceCommandService();
    _initializeRecorder();
    _prepareResponseStreaming();

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
    if (isPlaying) {
      await _player.pausePlayer(); // Pause the audio
    } else {
      await _player.startPlayer(
        fromURI: filePath,
        codec: Codec.defaultCodec,
        whenFinished: () {
          setState(() {
            isPlaying = false; // Reset when playback finishes
          });
        },
      );
    }
    setState(() {
      isPlaying = !isPlaying; // Toggle play/pause state
    });
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
        _startStreamingResponse();
        _playAudio(audio.path);

      }
    });
  }



  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();

    super.dispose();
  }




  void _prepareResponseStreaming() {
    // Split the response into words and initialize brightness state
    _responseWords = _response.split(' ');
    _isWordBright = List.filled(_responseWords.length, false);
    _currentWordIndex = 0;
  }

  void _startStreamingResponse() {
    _prepareResponseStreaming(); // Reset response for new streaming

    Future.doWhile(() async {
      if (_currentWordIndex < _responseWords.length) {
        setState(() {
          _isWordBright[_currentWordIndex] = true;
          _currentWordIndex++;
        });
        await Future.delayed(Duration(milliseconds: 300));
        return true;
      }
      return false;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Text(
                'Medical Voice Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Record your audio to receive an intelligent response.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30),

              // Recording Button
              ElevatedButton.icon(
                onPressed: isRecording ? _stopRecording : _startRecording,
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                label: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: isRecording ? Colors.redAccent : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Play Audio Button
              ElevatedButton.icon(
                onPressed: _recordingPath.isNotEmpty ? () => _playAudio(_recordingPath) : null,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow), // Dynamic icon
                label: Text(isPlaying ? 'Pause Audio' : 'Play Recorded Audio'), // Dynamic label
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: isPlaying ? Colors.orange : Colors.blue.shade600, // Optional dynamic color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Send to API Button
              ElevatedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () => _sendAudioToApi(_recordingPath),
                icon: isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Icon(Icons.send),
                label: Text(isProcessing ? 'Processing...' : 'Send to API'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: isProcessing ? Colors.grey : Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Response Display with Streaming Effect
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Response',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      children: List.generate(_responseWords.length, (index) {
                        return AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: 16,
                            color: _isWordBright[index]
                                ? Colors.black
                                : Colors.black.withOpacity(0.3),
                            fontWeight: _isWordBright[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          child: Text('${_responseWords[index]} '),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}