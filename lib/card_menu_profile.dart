import 'package:flutter/material.dart';

class CardMenuProfile extends StatelessWidget {

  String title="";
  IconData icon;

  CardMenuProfile(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final card = Container(
      height: 150.0,
      width: 300.0,
      margin: EdgeInsets.only(
          top:80.0,
          left: 20.0
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueAccent,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 40, // can be whatever value you want
                alignment: Alignment.center,
                child: Icon(icon, size: 70, color: Colors.white),
              ),
              title: new Center(child: new Text(title,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                      color: Colors.white,
                  ),
                )
              ),
              //title: Text(title, style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
              //subtitle: Text(title, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        card
      ],
    );
  }
}