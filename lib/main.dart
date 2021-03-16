import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widgets/Weather.dart';
import 'package:weather_app/models/WeatherData.dart';

import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String errormsg;
  bool isLoading = false;
  WeatherData weatherData;
  Location mylocation = new Location();

  @override
  void initState() {
    super.initState();

    processWeather();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.lightGreenAccent,
          appBar: AppBar(
            title: Text('Weather App'),
          ),
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: weatherData != null
                        ? Weather(weather: weatherData)
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor:
                                new AlwaysStoppedAnimation(Colors.black),
                          )
                        : IconButton(
                            icon: new Icon(Icons.refresh),
                            tooltip: 'Refresh',
                            onPressed: () => null,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
            ),
          ]))),
    );
  }

  processWeather() async {
    setState(() {
      isLoading = true;
    });

    LocationData location;
    try {
      location = await mylocation.getLocation();
      errormsg = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        errormsg = 'Permission Denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        errormsg = 'Permission denied - Location is disabled';
      }
      location = null;
    }
    if (location != null) {
      final lat = location.latitude;
      final lon = location.longitude;
      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?APPID=7ff7bcde0851ccf3fc9f7a044f62a817&lat=${lat.toString()}&lon=${lon.toString()}');
      if (weatherResponse.statusCode == 200) {
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          print(weatherData);
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
