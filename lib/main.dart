import 'package:flutter/material.dart';
import 'package:weatherisgoing/services/LocationService.dart';
import 'package:weatherisgoing/services/WeatherService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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

  bool _showFormDataError = false;
  bool _showFormLocationNotFoundError = false;
  bool _isLoading = false; // Variável para controlar o indicador de loading

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
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          'Carregando...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!_isLoading &&
                    actualTemp != null &&
                    minTemp != null &&
                    maxTemp != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cityController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'Temperatura atual: ${actualTemp!.toStringAsFixed(2)}°C'),
                        Text(
                            'Temperatura mínima: ${minTemp!.toStringAsFixed(2)}°C'),
                        Text(
                            'Temperatura máxima: ${maxTemp!.toStringAsFixed(2)}°C'),
                      ],
                    ),
                  ),
                if (_showFormDataError)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Insira os dados corretamente no formulário e clique em "Submit"',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_showFormLocationNotFoundError)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Localização não encontrada. Por favor, tente novamente.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      setState(() {
                        _isLoading = true;
                      });

                      LocationService.fetchCoordinates(_cityController.text,
                              _stateController.text, _countryController.text)
                          .then((Map<String, double> coordinates) {
                        var latitude = coordinates['latitude'] ?? 0.0;
                        var longitude = coordinates['longitude'] ?? 0.0;

                        setState(() {
                          if (latitude == -1 || longitude == -1) {
                            _showFormLocationNotFoundError = true;
                            actualTemp = null;
                            minTemp = null;
                            maxTemp = null;
                            _isLoading = false;
                            return;
                          } else {
                            WeatherService.fetchWeatherData(
                                    latitude, longitude, _apiKey)
                                .then((Map<String, dynamic> weatherData) {
                              actualTemp =
                                  kelvinToCelsius(weatherData['main']['temp']);
                              minTemp = kelvinToCelsius(
                                  weatherData['main']['temp_min']);
                              maxTemp = kelvinToCelsius(
                                  weatherData['main']['temp_max']);

                              _showFormDataError = false;
                              _showFormLocationNotFoundError = false;
                              _isLoading = false;
                            });
                          }
                        });
                      });
                    } else {
                      setState(() {
                        if (_cityController.text.isEmpty ||
                            _stateController.text.isEmpty ||
                            _countryController.text.isEmpty) {
                          _showFormDataError = true;
                          _isLoading = false;
                        } else {
                          _showFormLocationNotFoundError = true;
                          actualTemp = null;
                          minTemp = null;
                          maxTemp = null;
                          _isLoading = false;
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Enviar'),
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
