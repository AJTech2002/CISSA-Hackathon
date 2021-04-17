import 'package:flutter/material.dart';

import 'submission.dart';

// This page should show up after submitting the ratings
// Then it navigates to "submission.dart"
class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Additional Comment",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Do you have any other thought on this location? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            buildFeedbackForm(),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                FlatButton(
                  onPressed: () {
                    //////NEXT PAGE///////////////////
                    /////////////////////////////////
                    /////////////////////////////////
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        //////// NEXT PAGE HERE ///////////////////
                        //////////////////////////////////////////
                        return SubmissionPage(); // NEED REFACTOR
                      },
                    ));
                  },
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.white70,
                  padding: EdgeInsets.all(16.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildFeedbackForm() {
    return Container(
      height: 200,
      child: Stack(
        children: [
          TextField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "Please leave your comment here (optional)",
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white70,
                  width: 5.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
