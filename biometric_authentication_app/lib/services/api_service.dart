import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.100";

  static Future<bool> unlockDoor() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/unlock"),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
