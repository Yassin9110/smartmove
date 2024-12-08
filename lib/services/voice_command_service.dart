import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VoiceCommandService {
  final String apiUrl = "http://192.168.1.10:5002/Assistant";

  Future<Map<String, dynamic>> sendAudioToApi(String audioPath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final resonse_data = json.decode(responseBody);
        final answer_as_text = resonse_data["response"];
        print(responseBody);
        final audioBase64 = resonse_data['audio_data'];

        // Decode Base64 string to bytes
        final audioBytes = base64Decode(audioBase64);

        // Save audio to a file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/response_audio.wav';

        final audioFile = File(filePath);
        print("\n\n\n THHHHEEEEEE FILLLLLEEEEEE:  ${audioFile}  \n\n\n");
        await audioFile.writeAsBytes(audioBytes);
        return { "response" : answer_as_text, "audio" :audioFile } ;// Co// ntains "response", "signal", and "audio_url"
      } else {
        return {"error": "Failed to communicate with the server."};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }
}
