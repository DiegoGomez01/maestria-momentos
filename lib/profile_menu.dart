import 'package:flutter/material.dart';
import 'package:maestria_proyecto_momentos/card_menu_profile.dart';
import 'package:maestria_proyecto_momentos/publications.dart';
import 'package:maestria_proyecto_momentos/profile.dart';

class ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Perfil",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
        ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.all(25.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              new GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Publications()),
                  );
                },
                child: CardMenuProfile("Publications", Icons.insert_drive_file),
              ),
              new GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                child: CardMenuProfile("Profile", Icons.person),
              )
              //CardMenuProfile("Publications", Icons.insert_drive_file),
              //CardMenuProfile("Profile", Icons.person),
            ],
          ),
        ),
      ),
    );
    return Container(
      child: ListView(
        padding: EdgeInsets.all(25.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CardMenuProfile("Publications", Icons.album),
          CardMenuProfile("Profile", Icons.album),
        ],
      ),
    );
  }

}