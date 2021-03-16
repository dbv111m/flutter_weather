import 'dart:convert';
import 'package:flutter_weather/components/searchForm.dart';
import 'package:flutter_weather/components/weatherCard.dart';
import 'package:flutter_weather/helpers/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Geolocator _geo = Geolocator()..forceAndroidLocationManager;
  Position _position;
  String _city;
  int _temp;
  String _icon;
  String _desc;
  WeatherFetch _weatherFetch = new WeatherFetch();

  @override
  void initState() {
    _city = "blanc";
    _temp = 0;
    _icon = "04n";
    super.initState();
    _getCurrent();
  }

  /* Render data */
  void updateData(weatherData) {
    setState(() {
      if (weatherData != null) {
        debugPrint(jsonEncode(weatherData));
        //{"temp":10.49,"feels_like":5.54,"temp_min":10,"temp_max":11,"pressure":1009,"humidity":61}
        _temp = weatherData['main']['temp'].toInt();
        _icon = weatherData['weather'][0]['icon'];
        _desc = weatherData['main']['feels_like'].toString();
        // _color = _getBackgroudColor(_temp);
      } else {
        _temp = 0;
        _city = "In the middle of nowhere";
        _icon = "04n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Search(
                parentCallback: _changeCity,
              ),
              Text(
                _city,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              WeatherCard(
                title: _desc,
                temperature: _temp,
                iconCode: _icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCurrent() {
    _geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then(
      (Position position) {
        setState(() {
          _position = position;
          debugPrint(position.toString());
        });

        getCityAndWeather();
      },
    );
  }

  getCityAndWeather() async {
    try {
      List<Placemark> p = await _geo.placemarkFromCoordinates(
        _position.latitude,
        _position.longitude,
      );
      Placemark place = p[0];
      print(place);
      print(
        jsonEncode(
          place,
        ),
      );
      print(place.locality);
      var data = await _weatherFetch.getWeatherByCoord(
        _position.latitude,
        _position.longitude,
      );
      debugPrint(
        jsonEncode(
          data,
        ),
      );
      updateData(data);
      setState(
        () {
          _city = place.locality;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  _changeCity(city) async {
    try {
      var data = await _weatherFetch.getWeatherByName(city);
      updateData(data);
      setState(() {
        _city = city;
      });
    } catch (e) {
      print(e);
    }
  }
}
