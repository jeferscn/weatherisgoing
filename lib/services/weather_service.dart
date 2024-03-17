import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>> fetchWeatherData(double latitude, double longitude, String apiKey) async {
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }
}
