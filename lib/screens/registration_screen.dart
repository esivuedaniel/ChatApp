
import 'package:firebase_chating_app/component/rounded_button.dart';
import 'package:firebase_chating_app/constants.dart';
import 'package:firebase_chating_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id='registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
  String email, password;

  String _result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Text(_result==null?"":_result,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54
              ),),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: "Register", color: Colors.blueAccent,
                onPressed: () async{
                setState(() {
                  showSpinner=true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser !=null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }else{
                    _result="Error";
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }catch(e){
                  print(e);
                }
              }
              ,),
            ],
          ),
        ),
      ),
    );
  }
}
