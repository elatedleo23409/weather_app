import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widgets/Weather.dart';
import 'package:weather_app/models/WeatherData.dart';

import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final areacontroller = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    areacontroller.dispose();
    super.dispose();
  }

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: Column(children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: areacontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the location to know the weather",
                        labelText: "Search",
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Nextscreen(value: areacontroller.text),
                              ),
                            );
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
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
            ])));
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
          'https://api.openweathermap.org/data/2.5/weather?APPID=7ff7bcde0851ccf3fc9f7a044f62a817&lat=${lat.toString()}&lon=${lon.toString()}&units=metric');
      if (weatherResponse.statusCode == 200) {
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}

class Nextscreen extends StatefulWidget {
  String value;

  Nextscreen({Key key, this.value}) : super(key: key);
  @override
  _NextscreenState createState() => _NextscreenState();
}

class _NextscreenState extends State<Nextscreen> {
  WeatherData cityData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    weathercity();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.value}'s weather"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  cityData != null ? Weather(weather: cityData) : Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: new AlwaysStoppedAnimation(Colors.black),
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
    );
  }

  weathercity() async {
    setState(() {
      isLoading = true;
    });
    final cityResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?APPID=7ff7bcde0851ccf3fc9f7a044f62a817&q=${widget.value}&units=metric');
    if (cityResponse.statusCode == 200) {
      return setState(() {
        cityData = new WeatherData.fromJson(jsonDecode(cityResponse.body));
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
