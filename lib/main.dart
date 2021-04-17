import 'package:flutter/material.dart';
import 'gpsCalculator.dart';
import 'search.dart';
import 'base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homepage.dart';
import 'ui/circle_button.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'ui/search_ui.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: WelcomePage(),
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

  bool searchSectionOpen = false;

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

  void createUserMapPosition(bool move) {
    _controller.removeCircle(userCircle);
    if (userCircle == null) {
      _controller
          .addCircle(
            CircleOptions(
              circleRadius: 12.0,
              circleColor: '#3885ff',
              circleOpacity: 1,

              // YOU NEED TO PROVIDE THIS FIELD!!!
              // Otherwise, you'll get a silent exception somewhere in the stack
              // trace, but the parameter is never marked as @required, so you'll
              // never know unless you check the stack trace
              geometry: new LatLng(
                  _currentPosition.latitude, _currentPosition.longitude),
              draggable: false,
            ),
          )
          .then((value) => userCircle = value)
          .then((v) {
        if (move)
          _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(
              _currentPosition.latitude, _currentPosition.longitude)));
      });
    } else {
      _controller
          .updateCircle(
              userCircle,
              CircleOptions(
                circleRadius: 12.0,
                circleColor: '#3885ff',
                circleOpacity: 1,

                // YOU NEED TO PROVIDE THIS FIELD!!!
                // Otherwise, you'll get a silent exception somewhere in the stack
                // trace, but the parameter is never marked as @required, so you'll
                // never know unless you check the stack trace
                geometry: new LatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
                draggable: false,
              ))
          .then((v) {
        if (move)
          _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(
              _currentPosition.latitude, _currentPosition.longitude)));
      });
    }
  }

  void updateMapPosition() {}

  void clearPoints() {
    _controller.clearCircles();
    createUserMapPosition(false);
  }

  void addPoints(List<Place> points) {
    currentlyLoaded = points;
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        _controller.moveCamera(CameraUpdate.newLatLng(
            new LatLng(points[i].position.lat, points[i].position.lon)));
      }

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
      else if (i > 5) colorString = "#ff2e1f";

      _controller.addCircle(CircleOptions(
        circleRadius: 10.0,
        circleColor: colorString,
        circleOpacity: 1,
        geometry: new LatLng(points[i].position.lat, points[i].position.lon),
        draggable: false,
      ));
    }
  }

  Position _currentPosition;

  _getCurrentLocation(Function(Position) then) {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      then(position);
    }).catchError((e) {
      print(e);
    });
  }

  String searchQuery = "";

  void _settingModalBottomSheet(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    List<Widget> tempPlaces = new List<Widget>();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.white12,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Search Results for "' + searchQuery + '"',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  ...tempPlaces
                ],
              ));
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
              accessToken:
                  "pk.eyJ1IjoiYXZlbmsyIiwiYSI6ImNqcTV3ZG50bTI5MXM0OXVpbGdwdnBjaWoifQ.tReRhSlsmVBqt8lwwq1wHg",
              styleString: "mapbox://styles/avenk2/cjqaxhjumfqds2spbiudepom4",
              initialCameraPosition: CameraPosition(
                zoom: 15.0,
                target: LatLng(-37.7983, 144.9610),
              ),
              compassEnabled: false,
              tiltGesturesEnabled: false,
              onMapCreated: (MapboxMapController controller) {
                setState(() {
                  _controller = controller;
                });
              },
              onMapClick: (point, lat) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: SearchBar(
                      pointsFound: (points, text) {
                        setState(() {
                          searchQuery = text;
                          currentlyLoaded = points;
                        });
                        _settingModalBottomSheet(context);
                        addPoints(points);
                      },
                      clearPoints: () => clearPoints())),
            ),
            Text((_currentPosition != null)
                ? (_currentPosition.latitude.toString() +
                    " , " +
                    _currentPosition.longitude.toString())
                : "NONE"),
            Align(
              alignment: Alignment.topRight,
              child: CircleButton(
                icon: Icon(Icons.location_on, color: Colors.white),
                margin: EdgeInsets.only(top: 20, right: 20),
                tapCallback: () {
                  _controller.moveCamera(CameraUpdate.newLatLng(new LatLng(
                      _currentPosition.latitude, _currentPosition.longitude)));
                  _getCurrentLocation((pos) {
                    createUserMapPosition(true);
                  });
                },
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: CircleButton(
                  icon: Icon(Icons.add_location, color: Colors.white),
                  margin: EdgeInsets.only(top: 100, right: 20),
                  tapCallback: () {
                    print("Switch");
                  },
                ))
          ],
        )),
      ),
    );
  }
}
