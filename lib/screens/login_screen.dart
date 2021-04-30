import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chating_app/component/rounded_button.dart';
import 'package:firebase_chating_app/constants.dart';
import 'package:firebase_chating_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id='login_screen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner=false;
  String email, password;
  final _auth=FirebaseAuth.instance;
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
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Email"),
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
              RoundedButton(title: "Log in", color: Colors.lightBlue,
                onPressed: () async{

                setState(() {
                  showSpinner=true;
                });
                try{
              final signin= await _auth.signInWithEmailAndPassword(email: email, password: password);
              if(signin !=null){
                Navigator.pushNamed(context, ChatScreen.id);
              }else{
                _result="User not registered";
              }
              setState(() {
                showSpinner=false;
              });
                }catch(e){
                  print(e);
                }

              },),
            ],
          ),
        ),
      ),
    );
  }
}
