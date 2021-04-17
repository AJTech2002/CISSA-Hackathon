import 'package:LocationRater/base.dart';
import 'package:LocationRater/search.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.pointsFound, this.clearPoints}) : super(key: key);

  final Function(List<Place>, String) pointsFound;
  final Function clearPoints;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  String currentText = "";


  
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50),
        height: 80,
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(style: BorderStyle.solid, color: Colors.grey.shade200, width: 2),
          
        ),

        child: Row(
          children: [
            Expanded(
                flex: 90,
                child: TextField(
                style: TextStyle
                (
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: null,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (s)
                {
                  setState(() {
                    currentText = s;
                  });
                  
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: IconButton(icon: Icon(Icons.arrow_right), onPressed: () {
                widget.clearPoints();
                search(currentText.toLowerCase().trim()).then((value) => widget.pointsFound(value, currentText));
              }),
            )
          ],
        )
    );
  }
}