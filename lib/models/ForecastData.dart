import 'package:weather_app/models/WeatherData.dart';

class ForecastData {
  final List list;

  ForecastData({this.list});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    List list = [];

    for (dynamic e in json['list']) {
      WeatherData w = new WeatherData(
          date: new DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000,
              isUtc: false),
          name: json['city']['name'],
          temp: e['main']['temp'].toDouble(),
          icon: e['weather'][0]['icon']);
      list.add(w);
    }

    return ForecastData(
      list: list,
    );
  }
}