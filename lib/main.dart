import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'gpsCalculator.dart';
import 'search.dart';
import 'base.dart';
import 'homepage.dart';
import 'ui/circle_button.dart';
import 'ui/search_ui.dart';
import 'ui/place.dart';
import 'firebase.dart';
import 'ui/rater.dart';
import 'ui/new_rating.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  //Hello////
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

  Position _currentPosition;
  String searchQuery = "";

  Place selectedPlace = null;
  bool ratingPanel = false;

  bool loadingLocation = false;
  bool didMakeRatingChange = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation((p) {});
  }

  void createUserMapPosition(bool move) {
    //_controller.removeCircle(userCircle);

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
                circleRadius: 8.0,
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
    userCircle = null;
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

      // if (i == 0)
      //   colorString = "#1fff57";
      // else if (i == 1)
      //   colorString = "#b4ff1f";
      // else if (i == 2)
      //   colorString = "#fff41f";
      // else if (i == 3)
      //   colorString = "#ffa51f";
      // else if (i == 4)
      //   colorString = "#ff5e1f";
      // else if (i >= 5) colorString = "#ff2e1f";
      // else colorString = "#ff2e1f";

      colorString = "#ff2e17";

      _controller.addCircle(CircleOptions(
        circleRadius: 12,
        circleColor: colorString,
        circleOpacity: 0.8,
        geometry: new LatLng(points[i].position.lat, points[i].position.lon),
        draggable: false,
      ));
    }
  }

  _getCurrentLocation(Function(Position) then) {
    setState(() {
      loadingLocation = true;
    });
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        loadingLocation = false;
        _currentPosition = position;
      });
      then(position);
    }).catchError((e) {
      print(e);
    });
  }

  void _settingModalBottomSheetAddLocation(
      BuildContext context, String address) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    Navigator.push(context, MaterialPageRoute(builder: (cont) {
      return NewRating(
        address: address,
        currentPosition:
            new LatLon(_currentPosition.latitude, _currentPosition.longitude),
      );
    }));
  }

  void _settingModalBottomSheet(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    List<Widget> tempPlaces = new List<Widget>();

    for (int i = 0; i < currentlyLoaded.length.clamp(0, 4); i++) {
      tempPlaces.add(new PlaceWidget(
        place: currentlyLoaded[i],
        focusOn: (place) {
          Navigator.pop(context);
          focusOn(place, true);
        },
        index: i,
      ));
      tempPlaces.add(new Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        height: 1,
        color: Colors.grey.shade300,
      ));
    }

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
                  (tempPlaces.length <= 0)
                      ? Text('No Search Results Found')
                      : Container(),
                  ...tempPlaces
                ],
              ));
        });
  }

  bool approximatelyEqual(double a, double b) {
    if ((a - b).abs() < 0.0000001) {
      return true;
    } else
      return false;
  }

  Future<Place> findPlace(LatLon pos) {
    return fetchAll().then((places) {
      print("NEED : " + pos.lat.toString() + " , " + pos.lon.toString());
      for (int i = 0; i < places.length; i++) {
        print(places[i].position.lat.toString() +
            " , " +
            places[i].position.lon.toString());
        if (approximatelyEqual(places[i].position.lat, pos.lat) &&
            approximatelyEqual(places[i].position.lon, pos.lon)) {
          return places[i];
        }
      }

      return null;
    });
  }

  void focusOn(Place place, bool move) {
    if (move)
      _controller.moveCamera(CameraUpdate.newLatLng(
          new LatLng(place.position.lat, place.position.lon)));
    setState(() {
      didMakeRatingChange = false;
      ratingPanel = true;
      selectedPlace = place.copy();
    });
  }

  void onCircleTapped(Circle tappedCircle) {
    findPlace(new LatLon(tappedCircle.options.geometry.latitude,
            tappedCircle.options.geometry.longitude))
        .then((place) {
      if (place != null) {
        focusOn(place, false);
      }
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

                  _controller.onCircleTapped.add((argument) {
                    onCircleTapped(argument);
                  });
                });
                _getCurrentLocation((pos) {
                  createUserMapPosition(true);
                });
              },
              onMapClick: (point, lat) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                if (ratingPanel) {
                  setState(() {
                    ratingPanel = false;
                  });
                }
              },
            ),
            (!ratingPanel)
                ? Align(
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
                  )
                : Container(),
            Center(child: loadingLocation ? Text("Loading...") : null),
            Align(
              alignment: Alignment.bottomLeft,
              child: CircleButton(
                icon: Icon(Icons.location_on, color: Colors.white),
                margin: EdgeInsets.only(
                    bottom: (ratingPanel && selectedPlace != null) ? 30 : 130,
                    left: 20),
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
              alignment: Alignment.bottomLeft,
              child: CircleButton(
                icon: Icon(Icons.add, color: Colors.white),
                margin: EdgeInsets.only(
                    bottom: (ratingPanel && selectedPlace != null) ? 30 : 130,
                    left: 80),
                tapCallback: () {
                  setState(() {
                    loadingLocation = true;
                  });

                  getAddress(new LatLon(_currentPosition.latitude,
                          _currentPosition.longitude))
                      .then((value) {
                    setState(() {
                      loadingLocation = false;
                    });

                    getByAddress(value).then((foundLocation) {
                      if (foundLocation == null) {
                        _settingModalBottomSheetAddLocation(context, value);
                      } else {
                        focusOn(foundLocation, true);
                      }
                    });
                  });
                },
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: (ratingPanel && selectedPlace != null)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        margin: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(1),
                        ),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 8.0,
                                      left: 20,
                                      right: 20),
                                  child: Text(
                                    selectedPlace.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 8.0,
                                    bottom: 15.0),
                                child: Text(selectedPlace.address),
                              ),
                            ),
                            Rater(
                              callbackSubmit: (place) {
                                setState(() {
                                  Place modified = firebaseStore(place);
                                  place = null;
                                  ratingPanel = false;
                                });
                              },
                              selectedPlace: selectedPlace,
                              didChange: (b) {
                                didMakeRatingChange = b;
                              },
                              didCancel: () {
                                setState(() {
                                  ratingPanel = false;
                                });
                              },
                            )
                          ],
                        ))
                    : Container()),
          ],
        )),
      ),
    );
  }
}
