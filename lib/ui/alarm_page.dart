import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';


Future<String> fetchConnectionStatus() async {
  final String url = "http://192.168.1.10:5002/testConnection";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'];
    } else {
      return "Failed to connect to the server. Status code: ${response.statusCode}";
    }
  } catch (e) {
    return "An error occurred: $e";
  }
}

class TestConnectionPage extends StatefulWidget {
  @override
  _TestConnectionPageState createState() => _TestConnectionPageState();
}

class _TestConnectionPageState extends State<TestConnectionPage> {
  String _connectionStatus = "Click the button to test connection";

  void testConnection() async {
    String result = await fetchConnectionStatus();
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test API Connection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _connectionStatus,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: testConnection,
              child: Text("Test Connection"),
            ),
          ],
        ),
      ),
    );
  }
}