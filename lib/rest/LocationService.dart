import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherisgoing/models/place.dart';

class LocationService {
  static Future<List<Place>> fetchPlaces() async {
    var url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=Curitiba,Paraná,Brazil');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Place.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }
}