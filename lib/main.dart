import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'gpsCalculator.dart';

import 'base.dart';

import 'ui/search_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  //Hello
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MapboxMapController _controller;
  double lat;
  double lon;


  void addPoints (List<Place> points)
  {
    print ("Came Back");
    for (int i = 0; i < points.length; i++)
    {
      print("FOUND : " + points[i].name);
      _controller.addCircle(
        CircleOptions(
            circleRadius: 8.0,
            circleColor: '#006992',
            circleOpacity: 0.8,
          
            geometry: new LatLng(points[i].position.lat,points[i].position.lon),
            draggable: false,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
            children: [
              MapboxMap(
                accessToken: "pk.eyJ1IjoiYXZlbmsyIiwiYSI6ImNqcTV3ZG50bTI5MXM0OXVpbGdwdnBjaWoifQ.tReRhSlsmVBqt8lwwq1wHg",
                styleString: "mapbox://styles/avenk2/ckm1mxc0z44qg17qsqpgs0lzr",
                initialCameraPosition: CameraPosition(
                  zoom: 15.0,
                  target: LatLng(-37.8136, 144.9631),
                ),

                onMapCreated: (MapboxMapController controller) {

                  getCurrentLocation().then((value) {
                    setState(() {
                      lat = value.lat;
                      lon = value.lon;
                    });
                    
                    controller.animateCamera(
                      CameraUpdate.newLatLng(new LatLng(lat, lon))
                    );
                  });
                },

                onMapClick: (point, lat)
                {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },

              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SearchBar(
                  pointsFound: (points) => addPoints(points),
                ),
              )
            ],
          )
      ),
    );
  }
}
