import 'package:flutter/material.dart';
import '../base.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Rater extends StatefulWidget {
  Rater({Key key, this.selectedPlace, this.callbackSubmit, this.didChange, this.didCancel}) : super(key: key);

  final Place selectedPlace;
  final Function(Place) callbackSubmit;
  final Function(bool) didChange;
  final Function didCancel;

  @override
  _RaterState createState() => _RaterState();
}

class _RaterState extends State<Rater> {
  bool didMakeRatingChange = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15.0, bottom: 5.0),
              child: Text("Social Distancing Rating (${widget.selectedPlace.ratingCount})", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 5.0, bottom: 15.0),
              child: SmoothStarRating(
                allowHalfRating: true,
                onRated: (rating) {
                  setState(() {
                    widget.selectedPlace.socialDistancingScore = ((widget.selectedPlace.ratingCount * widget.selectedPlace.socialDistancingScore) + (rating)) / (widget.selectedPlace.ratingCount + 1);
                    didMakeRatingChange = true;
                    widget.didChange(true);
                  });
                },
                starCount: 5,
                size: 30.0,
                isReadOnly: false,
                color: Colors.orange.shade300,
                borderColor: Colors.orange.shade400,
                spacing: 0.0,
                rating: widget.selectedPlace.socialDistancingScore,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15.0, bottom: 5.0),
              child: Text("Cleanliness Rating (${widget.selectedPlace.ratingCount})", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 5.0, bottom: 15.0),
              child: SmoothStarRating(
                  allowHalfRating: true,
                  onRated: (rating) {
                    setState(() {
                      widget.selectedPlace.cleanlinessScore = ((widget.selectedPlace.ratingCount * widget.selectedPlace.cleanlinessScore) + (rating)) / (widget.selectedPlace.ratingCount + 1);
                      didMakeRatingChange = true;
                      widget.didChange(true);
                    });
                  },
                  starCount: 5,
                  size: 30.0,
                  isReadOnly: false,
                  color: Colors.orange.shade300,
                  borderColor: Colors.orange.shade400,
                  spacing: 0.0,
                  rating: widget.selectedPlace.cleanlinessScore),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15.0, bottom: 5.0),
              child: Text("Staff Friendliness and COVID Compliance Rating (${widget.selectedPlace.ratingCount})", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 5.0, bottom: 15.0),
              child: SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  onRated: (rating) {
                    setState(() {
                      widget.selectedPlace.staffFriendlinessScore = ((widget.selectedPlace.ratingCount * widget.selectedPlace.staffFriendlinessScore) + (rating)) / (widget.selectedPlace.ratingCount + 1);
                      didMakeRatingChange = true;
                      widget.didChange(true);
                    });
                  },
                  size: 30.0,
                  isReadOnly: false,
                  color: Colors.orange.shade300,
                  borderColor: Colors.orange.shade400,
                  spacing: 0.0,
                  rating: widget.selectedPlace.staffFriendlinessScore),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 5.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          if (didMakeRatingChange) {
                            widget.selectedPlace.ratingCount += 1;
                            didMakeRatingChange = false;
                            widget.callbackSubmit(widget.selectedPlace);
                            widget.didChange(false);
                          }
                        });
                      },
                      elevation: didMakeRatingChange ? 2.0 : 0.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 25.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        widget.didCancel();
                      },
                      elevation: 0.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        size: 25.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
