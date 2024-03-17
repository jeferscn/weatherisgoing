import 'package:flutter/material.dart';
import 'package:weatherisgoing/services/location_service.dart';
import 'package:weatherisgoing/services/weather_service.dart';
import 'package:weatherisgoing/provider/search_history.dart';

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
  static const String _weatherApiKey = "4a851493f6b050dbda06a01060475b2d";

  double? actualTemp;
  double? minTemp;
  double? maxTemp;
  String? weather;
  int? humidity;

  bool _showFormInputError = false;
  bool _showFormLocationNotFoundError = false;
  bool _isLoading = false;

  List<String> _searchHistoryList = [];
  late SearchHistory _searchHistory;

  @override
  void initState() {
    super.initState();
    _initializeSearchHistory();
  }

  Future<void> _initializeSearchHistory() async {
    var searchHistoryList = await SearchHistory().getSearchHistory();
    var searchHistory = SearchHistory();
    setState(() {
      _searchHistoryList = searchHistoryList;
      _searchHistory = searchHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather is Going...'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20.0, right: 30.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            color: Colors.white,
                          ),
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
                      !_showFormLocationNotFoundError &&
                      !_showFormInputError &&
                      actualTemp != null &&
                      minTemp != null &&
                      maxTemp != null &&
                      weather != null &&
                      humidity != null
                  )
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hoje em ${_cityController.text}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              'O tempo está: $weather'),
                          Text(
                              'Humidade em: $humidity%'),
                          Text(
                              'Temperatura atual: ${actualTemp!.toStringAsFixed(1)}°C'),
                          Text(
                              'Temperatura mínima: ${minTemp!.toStringAsFixed(1)}°C'),
                          Text(
                              'Temperatura máxima: ${maxTemp!.toStringAsFixed(1)}°C'),
                        ],
                      ),
                    ),
                  if (!_isLoading &&
                      _showFormInputError &&
                      !_showFormLocationNotFoundError)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Insira os dados corretamente no formulário e clique em "Enviar"',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!_isLoading && _showFormLocationNotFoundError)
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
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: _cityController,
                      decoration: const InputDecoration(
                        hintText: 'Entre com a cidade',
                        labelText: 'Cidade',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: _stateController,
                      decoration: const InputDecoration(
                        hintText: 'Entre com o Estado',
                        labelText: 'Estado',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      controller: _countryController,
                      decoration: const InputDecoration(
                        hintText: 'Entre com o País',
                        labelText: 'País',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitButtonPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 10),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: const Text('Enviar'),
                  ),
                  if (_searchHistoryList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'Histórico de Pesquisas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: _searchHistoryList.reversed
                                .map((location) => Text(location))
                                .toList(),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool isValidLocation = await validateLocation();
      if (isValidLocation) {
        setState(() {
          _showFormLocationNotFoundError = false;
        });

        await fetchWeatherData();
      } else {
        setState(() {
          _showFormLocationNotFoundError = true;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _showFormInputError = true;
        _isLoading = false;
      });
    }
  }

  Future<bool> validateLocation() async {
    var coordinates = await LocationService.fetchCoordinates(
        _cityController.text.trim(),
        _stateController.text.trim(),
        _countryController.text.trim());
    var latitude = coordinates['latitude'] ?? 0.0;
    var longitude = coordinates['longitude'] ?? 0.0;

    return latitude != -1 && longitude != -1;
  }

  Future<void> fetchWeatherData() async {
    var coordinates = await LocationService.fetchCoordinates(
        _cityController.text.trim(),
        _stateController.text.trim(),
        _countryController.text.trim());
    var latitude = coordinates['latitude'] ?? 0.0;
    var longitude = coordinates['longitude'] ?? 0.0;

    if (latitude == -1 || longitude == -1) {
      setState(() {
        _isLoading = false;
        _showFormLocationNotFoundError = true;
        actualTemp = null;
        minTemp = null;
        maxTemp = null;
        weather = null;
        humidity = null;
      });
    } else {
      var weatherData = await WeatherService.fetchWeatherData(
          latitude, longitude, _weatherApiKey);
      setState(() {
        actualTemp = kelvinToCelsius(weatherData['main']['temp']);
        minTemp = kelvinToCelsius(weatherData['main']['temp_min']);
        maxTemp = kelvinToCelsius(weatherData['main']['temp_max']);
        weather = weatherData['weather'].first['main'];
        humidity = weatherData['main']['humidity'];

        _isLoading = false;
        _showFormInputError = false;
        _showFormLocationNotFoundError = false;

        _searchHistory
            .saveSearchHistory(
                '${_cityController.text.trim()}, ${_stateController.text.trim()}, ${_countryController.text.trim()}')
            .then((value) => _searchHistory
                .getSearchHistory()
                .then((value) => _searchHistoryList = value));
      });
    }
  }
}

double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;
}
