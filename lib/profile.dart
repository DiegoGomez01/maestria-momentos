import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Profile extends StatelessWidget {
  var dataUser;
  var contextGeneral;

  @override
  Widget build(BuildContext context) {
    this.contextGeneral = context;
    // TODO: implement build
    final appTitle = 'Editar Perfil';

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: FutureBuilder(
            future: _getDataUser(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return new Container (
                    padding: const EdgeInsets.all(30.0),
                    height: 800,
                    color: Colors.white,
                    child: new SingleChildScrollView(
                      child: MyCustomForm(dataUser)
                    ),
                );
              }
              else {
                return Container(
                  color: Colors.lightBlue,
                  child: Center(
                    child: Loading(indicator: BallPulseIndicator(), size: 100.0),
                  ),
                );
              }
            }
        ),
        /*body: new Container (
            padding: const EdgeInsets.all(30.0),
            height: 800,
            color: Colors.white,
            child: new SingleChildScrollView(
                child: MyCustomForm()
            )
        ),*/
    );
  }

  Future<bool> _getDataUser() async {
    await getUser();
    return Future.value(true);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.encodeFull("https://momentos-backend.herokuapp.com/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString('token')
        }
    );
    if ((response.statusCode >= 200 && response.statusCode < 210)) {
      this.dataUser = convert.jsonDecode(response.body)['data'];
    }else {
      return showMessage('Error', convert.jsonDecode(response.body)['message']);
    }
  }

  showMessage(title, desc) {
    Alert(
        context: contextGeneral,
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
              Navigator.of(contextGeneral, rootNavigator: true).pop();
            },
          )
        ]
    ).show();
  }

}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  var dataUser;
  MyCustomForm(this.dataUser);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(this.dataUser);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {

  var dataUser;
  MyCustomFormState(this.dataUser);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassworwController = TextEditingController();
  final _ageController = TextEditingController();
  var contextGeneral;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    contextGeneral = context;
    _nameController.text = dataUser[0]['name'];
    _emailController.text = dataUser[0]['email'];
    _ageController.text = dataUser[0]['age'].toString();
    print(dataUser[0]);
    return new Form(
        key: _formKey,
        child: new Column(
            children : [
              new Padding(padding: EdgeInsets.only(top: 30.0)),
              new Text('Editar Perfil',
                style: new TextStyle(color: Color(int.parse("#F2A03D".substring(1, 7), radix: 16) + 0xFF000000), fontSize: 25.0),),
              new Padding(padding: EdgeInsets.only(top: 50.0)),
              new TextFormField(
                controller: _nameController,
                decoration: new InputDecoration(
                  labelText: 'Nombre',
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
                    return "Name cannot be empty";
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
                controller: _emailController,
                decoration: new InputDecoration(
                  labelText: 'Correo',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Description cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                maxLines: null,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              new TextFormField(
                controller: _ageController,
                decoration: new InputDecoration(
                  labelText: 'Age',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Age cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                maxLines: null,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              new TextFormField(
                controller: _passwordController,
                decoration: new InputDecoration(
                  labelText: 'Contraseña',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                validator: (val) {
                    return null;
                },
                keyboardType: TextInputType.text,
                maxLines: null,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              new TextFormField(
                controller: _confirmPassworwController,
                decoration: new InputDecoration(
                  labelText: 'Confirmar contraseña',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                validator: (val) {
                  if(_passwordController.text != val) {
                    return "Password not match";
                  }else{
                    if(val.length > 0 && val.length < 8) {
                      return "Passwords must be at least 8 characters";
                    }
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
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
                      save(_nameController.text, _passwordController.text, _emailController.text, _ageController.text);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ]
        )
    );

  }

  save(name, password, email, age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.patch(
        Uri.encodeFull("https://momentos-backend.herokuapp.com/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString('token')
        },
        body: convert.jsonEncode({
          "name": name,
          "password": password,
          "email": email,
          "age": age,
        }),
    );
    if ((response.statusCode >= 200 && response.statusCode < 210)) {
      this._nameController.text = name;
      this._emailController.text = email;
      this._ageController.text = age;
      this._passwordController.text = '';
      this._confirmPassworwController.text = '';
    }
    return Alert(
        context: contextGeneral,
        title: 'Error',
        desc: convert.jsonDecode(response.body)['message'],
        style: AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(contextGeneral, rootNavigator: true).pop();
            },
          )
        ]
    ).show();
  }

}