import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'gpsCalculator.dart';
import 'package:geolocator/geolocator.dart';
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
  Circle userCircle;
  double lat;
  double lon;

  List<Place> currentlyLoaded = new List<Place>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation((p) {});

    Future.delayed(Duration(milliseconds: 2000), () {
      createUserMapPosition(true);
    });
    
  }


  void createUserMapPosition (bool move)
  {
      if (userCircle == null)
      {
        _controller.addCircle(CircleOptions(
            circleRadius: 8.0,
            circleColor: '#ffffff',
            circleOpacity: 0.8,
            
            // YOU NEED TO PROVIDE THIS FIELD!!!
            // Otherwise, you'll get a silent exception somewhere in the stack
            // trace, but the parameter is never marked as @required, so you'll
            // never know unless you check the stack trace
            geometry: new LatLng(_currentPosition.latitude, _currentPosition.longitude),
            draggable: false,
          ),).then((value) => userCircle).then((v) {
            if (move)
            _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(_currentPosition.latitude, _currentPosition.longitude)));
          });
      }
      else {
        
        _controller.updateCircle(userCircle, CircleOptions(
            circleRadius: 8.0,
            circleColor: '#ffffff',
            circleOpacity: 0.8,
            
            // YOU NEED TO PROVIDE THIS FIELD!!!
            // Otherwise, you'll get a silent exception somewhere in the stack
            // trace, but the parameter is never marked as @required, so you'll
            // never know unless you check the stack trace
            geometry: new LatLng(_currentPosition.latitude, _currentPosition.longitude),
            draggable: false,
          )).then((value) => userCircle).then((v) {
            if (move)
            _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(_currentPosition.latitude, _currentPosition.longitude)));
          });

      }
  }

  void updateMapPosition ()
  {
    
  }

  
  void clearPoints ()
  {
    _controller.clearCircles();
    createUserMapPosition(false);

  }

  void addPoints (List<Place> points)
  {
    currentlyLoaded = points;
    for (int i = 0; i < points.length; i++)
    {
      if (i == 0)
      {
        _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(points[i].position.lat, points[i].position.lon)));
      }

      print (((points[i].cleanlinessScore+points[i].socialDistancingScore+points[i].staffFriendlinessScore)/3)/5);

      String colorString = "";

      if (i == 0)
        colorString = "#1fff57";
      else if (i == 1)
        colorString = "#b4ff1f";
      else if (i == 2)
        colorString = "fff41f";
      else if (i == 3)
        colorString = "#ffa51f";
      else if (i == 4)
        colorString = "#ff5e1f";
      else if (i > 5)
        colorString = "#ff2e1f";


      _controller.addCircle(
        CircleOptions(
            circleRadius: 8.0,
            circleColor: colorString,
            circleOpacity: 0.8,
          
            geometry: new LatLng(points[i].position.lat,points[i].position.lon),
            draggable: false,
        )
      );
    }
    
  }

  Position _currentPosition;

  _getCurrentLocation(Function(Position) then) {
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
        then(position);
      }).catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  MapboxMap(
                    accessToken: "pk.eyJ1IjoiYXZlbmsyIiwiYSI6ImNqcTV3ZG50bTI5MXM0OXVpbGdwdnBjaWoifQ.tReRhSlsmVBqt8lwwq1wHg",
                    styleString: "mapbox://styles/avenk2/ck1yaasvr65je1dpa0t9ctuaq",
                    initialCameraPosition: CameraPosition(
                      zoom: 15.0,
                      target: LatLng(-37.8136, 144.9631),
                    ),

                    compassEnabled: false,
                    tiltGesturesEnabled: false,

                    onMapCreated: (MapboxMapController controller) {
                      
                      setState(() {
                        _controller = controller;
                      });
                      
                      
                      // getCurrentLocation().then((value) {
                      //   setState(() {
                      //     lat = value.lat;
                      //     lon = value.lon;
                      //   });
                        
                      //   controller.animateCamera(
                      //     CameraUpdate.newLatLng(new LatLng(lat, lon))
                      //   );
                      // });
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
                      clearPoints: () => clearPoints()
                    ),
                  ),
                  Text((_currentPosition != null) ? (_currentPosition.latitude.toString() + " , " + _currentPosition.longitude.toString()) : "NONE"),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container (
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(right: 20, top: 100),
                      decoration: BoxDecoration
                      (
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.orangeAccent.shade100, width: 2, style: BorderStyle.solid),
                      ),
                      child: Center(
                        child: Icon(Icons.star, color: Colors.white)
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        print("Tapped Location");
                        _getCurrentLocation((pos) {
                          createUserMapPosition(true);
                        });
                      },
                      child: Container (
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(right: 20, top: 20),
                        decoration: BoxDecoration
                        (
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.orangeAccent.shade100, width: 2, style: BorderStyle.solid),
                        ),
                        child: Center(
                          child: Icon(Icons.location_pin, color: Colors.white)
                        )
                      ),
                    )
                  )
                ],
              )
        ),
      ),
    );
  }
}
