import 'package:flutter/material.dart';
import 'rater.dart';
import '../firebase.dart';
import '../base.dart';

class NewRating extends StatefulWidget {
  NewRating({Key key, this.address, this.currentPosition}) : super(key: key);

  String address;
  LatLon currentPosition;

  @override
  _NewRatingState createState() => _NewRatingState();
}

class _NewRatingState extends State<NewRating> {
  Place creatingPlace;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    creatingPlace = new Place(widget.address, "Restaurant", widget.currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            color: Colors.white12,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 25.0, bottom: 15.0),
                    child: Text(
                      widget.address,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Place Name"),
                      onChanged: (v) {
                        creatingPlace.name = v;
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: Text(
                              "Type",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButton<String>(
                              value: creatingPlace.type,
                              onChanged: (String v) {
                                creatingPlace.type = v;
                              },
                              items: <String>["Shop", "Restaurant", "Cinema", "Hospital", "Bank", "General Services"].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                        ],
                      )),
                ),
                Rater(
                  callbackSubmit: (place) {
                    creatingPlace = place;
                    storeNew(creatingPlace);
                    place = null;
                    Navigator.pop(context);
                  },
                  selectedPlace: creatingPlace,
                  didChange: (b) {},
                  didCancel: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )),
      ),
    );
  }
}
