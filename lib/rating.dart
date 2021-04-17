import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingPage extends StatefulWidget {
  RatingPage({Key key}) : super(key: key);
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  //
  double _rating1;
  double _rating2;
  double _rating3;
  IconData _selectedIcon;
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Rate The Location'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // first score
              SizedBox(
                height: 40,
              ),
              _heading("Rate social distancing"),
              _ratingBar(1),
              SizedBox(
                height: 20,
              ),
              _rating1 != null
                  ? Text(
                      'Rating: $_rating1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Container(),
              // second score
              SizedBox(
                height: 40.0,
              ),
              _heading("Rate cleanliness"),
              _ratingBar(2),
              SizedBox(
                height: 20,
              ),
              _rating2 != null
                  ? Text(
                      'Rating: $_rating2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Container(),
              // third score
              SizedBox(
                height: 40.0,
              ),
              _heading("Rate staff friendliness"),
              _ratingBar(3),
              SizedBox(
                height: 20,
              ),
              _rating3 != null
                  ? Text(
                      'Rating: $_rating3',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(int index) {
    switch (index) {
      case 1:
        return RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating1 = rating;
            });
          },
        );
      case 2:
        return RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating2 = rating;
            });
          },
        );
      case 3:
        return RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating3 = rating;
            });
          },
        );
    }
  }

  Widget _heading(String text) => Column(
        children: [
          Text(text,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
              )),
          SizedBox(
            height: 20,
          )
        ],
      );
}
