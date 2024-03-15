import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weatherisgoing/rest/LocationService.dart';
import 'package:weatherisgoing/models/place.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

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
                      print(_cityController.text);
                      print(_stateController.text);
                      print(_countryController.text);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
