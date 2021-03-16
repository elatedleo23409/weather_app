class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  
  final String icon;

  WeatherData({this.date, this.name, this.temp, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false),
      name: json['name'],
      temp: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}