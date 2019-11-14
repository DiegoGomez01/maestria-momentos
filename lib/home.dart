import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {

  getPermission() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    print(position);
  }

  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    //_getAllPublications();
    getdata();
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
            new MarkerLayerOptions(markers: [
              new Marker(
                  width: 45.0,
                  height: 45.0,
                  point: new LatLng(_currentPosition.latitude, _currentPosition.longitude),
                  builder: (context) => new Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Your position');
                      },
                    ),
                  )
              )
            ])
          ]
      )
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      // print(e);
    });
  }

  Future getdata() async {
    var res = await http.get(
        Uri.encodeFull("http://10.0.2.2:3000/publications/range/20"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwibmFtZSI6IkRpZWdvIiwiZW1haWwiOiJnb21lemRpZWdvMTk5OEBnbWFpbC5jb20iLCJpYXQiOjE1NzMzMTIxNjksImV4cCI6MTU3MzM5ODU2OX0.N1JA4EIAlXftpefO6U-RfN2CABXmbE7TdnbEWs3OEDQ"
        }
    );
    print(res.body);
  }

  _getAllPublications() async {
    print('llego');
    var response = await http.get(
        Uri.encodeFull("http://10.0.2.2:3000"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwibmFtZSI6IkRpZWdvIiwiZW1haWwiOiJnb21lemRpZWdvMTk5OEBnbWFpbC5jb20iLCJpYXQiOjE1NzMzMTIxNjksImV4cCI6MTU3MzM5ODU2OX0.N1JA4EIAlXftpefO6U-RfN2CABXmbE7TdnbEWs3OEDQ"
        }
    );
    if (response.statusCode > 200 && response.statusCode < 210) {
      var jsonResponse = convert.jsonDecode(response.body);
      //var itemCount = jsonResponse['totalItems'];
      print("Number of books about http: $jsonResponse.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }
}