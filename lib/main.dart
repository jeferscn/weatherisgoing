import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weatherisgoing/services/LocationService.dart';
import 'package:weatherisgoing/models/place.dart';
import 'package:weatherisgoing/services/WeatherService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _apiKey = "4a851493f6b050dbda06a01060475b2d";

  double? actualTemp;
  double? minTemp;
  double? maxTemp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather is Going...'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: 'Enter com a cidade',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com a cidade';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      hintText: 'Enter com o Estado',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com o Estado';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      hintText: 'Enter com o País',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com o País';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      LocationService.fetchCoordinates(_cityController.text,
                              _stateController.text, _countryController.text)
                          .then((Map<String, double> coordinates) {
                        var latitude = coordinates['latitude'] ?? 0.0;
                        var longitude = coordinates['longitude'] ?? 0.0;

                        WeatherService.fetchWeatherData(
                                latitude, longitude, _apiKey)
                            .then((Map<String, dynamic> weatherData) {
                          setState(() {
                            actualTemp =
                                kelvinToCelsius(weatherData['main']['temp']);
                            minTemp = kelvinToCelsius(
                                weatherData['main']['temp_min']);
                            maxTemp = kelvinToCelsius(
                                weatherData['main']['temp_max']);
                          });
                        });
                      });
                    } else {
                      print('Form is invalid');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold)),
                  child: Text('Submit'),
                ),
                if (actualTemp != null && minTemp != null && maxTemp != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            _cityController.text),
                        Text(
                            'Temperatura atual: ${actualTemp!.toStringAsFixed(2)}°C'),
                        Text(
                            'Temperatura mínima: ${minTemp!.toStringAsFixed(2)}°C'),
                        Text(
                            'Temperatura máxima: ${maxTemp!.toStringAsFixed(2)}°C'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;
}

double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;
}
