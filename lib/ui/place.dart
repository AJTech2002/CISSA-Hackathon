import 'package:flutter/material.dart';
import '../base.dart';

class PlaceWidget extends StatelessWidget {
  const PlaceWidget({Key key, this.place, this.index}) : super(key: key);

  final Place place;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        print (place.name);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    place.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 15.0),
                  child: Text(place.address),
                )),
          ],
        ),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
