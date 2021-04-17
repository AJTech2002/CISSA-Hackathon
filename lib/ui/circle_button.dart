import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  CircleButton({Key key, this.icon, this.tapCallback, this.margin}) : super(key: key);

  final Icon icon;
  final Function tapCallback;
  final EdgeInsets margin;
  

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {

  bool down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.tapCallback != null)
          {
            widget.tapCallback();
          }
        },
        onTapDown: (e) {
          setState(() {
            down = true;
          });
        },
        onTapUp: (e) {
           setState(() {
            down = false;
          });
        },
        child: AnimatedContainer (
          duration: Duration(milliseconds: 100),
          width: 50,
          height: 50,
          margin: widget.margin,
          decoration: BoxDecoration
          (
            color: down?Colors.orangeAccent:Colors.orangeAccent.shade700,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.orangeAccent.shade100, width: 2, style: BorderStyle.solid),
          ),
          child: Center(
            child: widget.icon,
          )
      ),
    );
  }
}