import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<Map<String, double>> fetchCoordinates(String city, String state, String country) async {
    var url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=$city,$state,$country');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        Map<String, dynamic> firstResult = jsonResponse.first;
        double latitude = double.parse(firstResult['lat'] ?? '-1');
        double longitude = double.parse(firstResult['lon'] ?? '-1');

        return {'latitude': latitude, 'longitude': longitude};
      } else {
        return {'latitude': -1, 'longitude': -1};
      }
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }
}