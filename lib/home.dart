import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {

  Position _currentPosition;
  var _markersView = [];

  addMarker(marker) async {
    double distanceInMeters = await Geolocator().distanceBetween(
        _currentPosition.latitude, _currentPosition.longitude, marker['latitude'], marker['longitude']);
    if(distanceInMeters < 1000) {
      return new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(marker['latitude'], marker['longitude']),
        builder: (context) => new Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.blueAccent,
            iconSize: 45.0,
            onPressed: () {
              return Alert(
                  context: context,
                  title: marker['title'],
                  desc: marker['message'],
                  style: AlertStyle(isCloseButton: false),
                  buttons: [
                    DialogButton(
                      child: Text(
                          "Ir",
                          style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        print("ir");
                      },

                    )
                  ]
              ).show();
            },
          ),
        )
      );
    }
    return null;
  }

  getMarkers() async {
    var markers = [
      new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(_currentPosition.latitude, _currentPosition.longitude),
          builder: (context) => new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.redAccent,
              iconSize: 45.0,
              onPressed: () {
                print('Marker tapped');
              },
            ),
          )
      )
    ];
    var marks = await _getAllPublications();
    for (var i = 0; i<marks['data'].length; i++) {
      var marker = await addMarker(marks['data'][i]);
      if(marker != null) {
        markers.add(marker);
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: new FlutterMap(
          options: new MapOptions( center: new LatLng(_currentPosition.latitude, _currentPosition.longitude), minZoom: 10.0),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                "https://api.mapbox.com/styles/v1/rajayogan/cjl1bndoi2na42sp2pfh2483p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGllZ29nb21leiIsImEiOiJjam5qaW1xeXMwenNsM2tueXFiZWZ1andiIn0.suJs58a1pOpL4c-rQzU2VA",
                additionalOptions: {
                  'accessToken':
                  'pk.eyJ1IjoiZGllZ29nb21leiIsImEiOiJjam5qaW1xeXMwenNsM2tueXFiZWZ1andiIn0.suJs58a1pOpL4c-rQzU2VA',
                  'id': 'mapbox.mapbox-streets-v7'
                }),
            new MarkerLayerOptions(markers: _markersView)
          ]
      )
    );
  }

  _getCurrentLocation() async {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        if(position != 'Unknown') {
          setState(() {
            _currentPosition = position;
            getMarkers().then((marks) => {
              setState(() {
                _markersView = marks;
              }
            )});
          });
        }
    });
  }

  _getCurrentLocation2() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  _getAllPublications() async {
    var response = await http.get(
        Uri.encodeFull("http://192.168.1.63:3000/publications"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwibmFtZSI6IkRpZWdvIiwiZW1haWwiOiJnb21lemRpZWdvMTk5OEBnbWFpbC5jb20iLCJpYXQiOjE1NzM4Njg4MTgsImV4cCI6MTU3Mzk1NTIxOH0.SrWAYxhSjqbHkXfj_W8xNCNwNN9Q-pkrKTuV6jFxlK8"
        }
    );
    if (response.statusCode >= 200 && response.statusCode < 210) {
      return convert.jsonDecode(response.body);
    } else {
      print(response.statusCode);
      return convert.jsonDecode("data:[]");
    }
  }
}