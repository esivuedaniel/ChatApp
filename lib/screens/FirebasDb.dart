import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase dataBase=FirebaseDatabase.instance;
class FirebasDb extends StatefulWidget {
  @override
  _FirebasDbState createState() => _FirebasDbState();
}

class _FirebasDbState extends State<FirebasDb> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('This is my database text',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black
        ),),

        Center(
          child: GestureDetector(
            onTap: (){
              // to save value to our firebase db
              dataBase.reference().child("message").set({
                "firstname":"Daniel",
                "lastName":"Esivue",
                "age": 20
              });
            },
            child: Material(
              color: Colors.lightGreen,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Press me',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
