import 'package:maestria_proyecto_momentos/home.dart';
import 'package:maestria_proyecto_momentos/profile_menu.dart';
import 'package:maestria_proyecto_momentos/create_publication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement buildreturnnull;
    return Scaffold(
      bottomNavigationBar: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                title: Text("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.create),
                title: Text("Crear"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
              )
            ]
        ),
        tabBuilder: (BuildContext context, int index){
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (BuildContext context) => Home(),
              );
              break;
            case 1:
              return CupertinoTabView(
                builder: (BuildContext context) => CreatePublication(),
              );
              break;
            case 2:
              return CupertinoTabView(
                builder: (BuildContext context) => ProfileMenu(),
              );
              break;
          }
        },
      ),
    );
  }
}