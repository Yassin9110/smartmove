//import 'package:flutter_blue/flutter_blue.dart';


class BluetoothService {
  // Simulate connecting to a device
  Future<void> connectToDevice() async {
    print("Mock: Connecting to ESP device...");
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
  }

  // Simulate sending data
  Future<void> sendData(String data) async {
    print("Mock: Sending data - $data");
    await Future.delayed(Duration(milliseconds: 500)); // Simulate delay
  }

  // Simulate checking Bluetooth availability
  bool isBluetoothAvailable() {
    print("Mock: Bluetooth is available.");
    return true;
  }
}

