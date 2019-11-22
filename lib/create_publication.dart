import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CreatePublication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final appTitle = 'Crear publicación';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: new Container (
            padding: const EdgeInsets.all(30.0),
            color: Colors.white,
            child: new SingleChildScrollView(
              child: MyCustomForm()
            )
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return new Form(
        key: _formKey,
        child: new Column(
            children : [
              new Padding(padding: EdgeInsets.only(top: 70.0)),
              new Text('Crear publicación',
                style: new TextStyle(color: Color(int.parse("#F2A03D".substring(1, 7), radix: 16) + 0xFF000000), fontSize: 25.0),),
              new Padding(padding: EdgeInsets.only(top: 50.0)),
              new TextFormField(
                controller: _titleController,
                decoration: new InputDecoration(
                  labelText: "Enter Title",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Title cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              new TextFormField(
                controller: _descriptionController,
                decoration: new InputDecoration(
                  labelText: "Enter Description",
                  fillColor: Colors.white,
                  contentPadding: new EdgeInsets.symmetric(vertical: 100.0, horizontal: 10.0),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Description cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      save(_titleController.text, _descriptionController.text);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ]
        )
    );
  }

  save(title, description) async {
    /*var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
              print(position);
          if(position != 'Unknown') {
            sendData(position, title, description);
          }
        });*/
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
            sendData(position, title, description);
    });
  }

  sendData(position, title, description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.encodeFull("http://192.168.1.63:3000/publications"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString('token')
        },
        body: convert.jsonEncode(
            {
              "title": title,
              "message": description,
              "idUser": prefs.getInt('idUser'),
              "lat": position.latitude,
              "lng": position.longitude
            }
        )
    );
    print(response.statusCode);
    if ((response.statusCode >= 200 && response.statusCode < 210)) {
      return showMessage('Success', convert.jsonDecode(response.body)['message']);
    }
    return showMessage('Error', convert.jsonDecode(response.body)['message']);
  }

  showMessage(title, desc) {
    Alert(
        context: context,
        title: title,
        desc: desc,
        style: AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              _titleController.text = '';
              _descriptionController.text = '';
            },
          )
        ]
    ).show();
  }

}