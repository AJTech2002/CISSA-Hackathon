import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Rating Page',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new RatingPage(),
    );
  }
}

class RatingPage extends StatefulWidget {
  RatingPage({Key key}) : super(key: key);
  @override
  _RatingPageState createState() => new _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // just a dummy variable
  int _selectedIndex = 0;

  // needs implementation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // needs implementation
  void sliderChanged(double value) {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Rate The Location'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Social Distancing",
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF082ae8),
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto"),
                  )
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Slider(
                    key: null,
                    onChanged: sliderChanged,
                    value: 0.35,
                  )
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Cleanliness",
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF1818ec),
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto"),
                  )
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Slider(
                    key: null,
                    onChanged: sliderChanged,
                    value: 0.35,
                  )
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Staff Friendliness",
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF1818ec),
                        fontWeight: FontWeight.w800,
                        fontFamily: "Roboto"),
                  )
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Slider(
                    key: null,
                    onChanged: sliderChanged,
                    value: 0.35,
                  )
                ]),
          ]),
      bottomNavigationBar: new BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_rounded),
            label: 'Submit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
