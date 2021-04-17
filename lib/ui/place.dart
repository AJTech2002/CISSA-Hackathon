import 'package:flutter/material.dart';
import '../base.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceWidget extends StatelessWidget {
  const PlaceWidget({Key key, this.place, this.index, this.focusOn}) : super(key: key);

  final Place place;
  final int index;
  final Function(Place) focusOn;

  //(place.cleanlinessScore+place.socialDistancingScore+place.staffFriendlinessScore)/3)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(place.name);
        focusOn(this.place);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        place.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: SmoothStarRating(allowHalfRating: true, starCount: 5, size: 25.0, isReadOnly: true, color: Colors.orange.shade300, borderColor: Colors.orange.shade400, spacing: 0.0, rating: (place.cleanlinessScore + place.socialDistancingScore + place.staffFriendlinessScore) / 3),
                      ),
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8.0, bottom: 15.0),
                  child: Text(place.address),
                )),
          ],
        ),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
