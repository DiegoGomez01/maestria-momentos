import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'menu_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  var contextGeneral;

  Future<String> _createUser(LoginData data) async {
    var response = await http.post(
        Uri.encodeFull("https://momentos-backend.herokuapp.com/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: convert.jsonEncode(
            {
              "name": data.name,
              "email": data.email,
              "password": data.password,
              "age": data.age
            }
          )
    );
    if (!(response.statusCode >= 200 && response.statusCode < 210)) {
      return convert.jsonDecode(response.body)['message'];
    }
    return '';
  }

  Future<String> _authUser(LoginData data) async {
    var response = await http.post(
        Uri.encodeFull("https://momentos-backend.herokuapp.com/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: convert.jsonEncode({'email':data.email, 'password':data.password})
    );
    if (!(response.statusCode >= 200 && response.statusCode < 210)) {
      return convert.jsonDecode(response.body)['message'];
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //int counter = (prefs.getInt('counter') ?? 0) + 1;
    //print('Pressed $counter times.');
    await prefs.setString('token', convert.jsonDecode(response.body)['token']);
    await prefs.setInt('idUser', convert.jsonDecode(response.body)['idUser']);
    prefs.commit();
    return '';
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.value('Building');
  }

  @override
  Widget build(BuildContext context) {
    this.contextGeneral = context;
    return FlutterLogin(
      title: 'Momentos',
      logo: 'assets/images/momentos.png',
      onLogin: _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenuBar(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}