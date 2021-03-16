import 'dart:convert';
import 'package:flutter_weather/components/searchForm.dart';
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

  @override
  void initState() {
    _city = "test";
    super.initState();
    _getCurrent();
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
      print(jsonEncode(place));
      print(place.locality);
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
      setState(() {
        _city = city;
      });
    } catch (e) {
      print(e);
    }
  }
}
