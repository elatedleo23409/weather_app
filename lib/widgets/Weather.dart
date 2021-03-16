import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/WeatherData.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weather.name, style: new TextStyle(color: Colors.black)),
        Text('${weather.temp.toString()}°', style: new TextStyle(color: Colors.black)),
        Text(new DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.black)),
        Text(new DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.black)),
      ],
    );
  }
}
