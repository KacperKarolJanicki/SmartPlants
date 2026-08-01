import 'package:backend_connection/backend_connection.dart';

String checkConnection = '';
String host = '';
bool isLoading = false;
Map<String,dynamic> fromSensorsData = {};

Future<String> checkConnectionStatus() async {
  try {
    checkConnection = await backend.download(host, host);
    return 'assets/images/connected.png';
  } catch (e) {
    checkConnection = 'Connection failed';
    return 'assets/images/disconnected.png';
  }
}