import 'package:firebase_chating_app/component/rounded_button.dart';
import 'package:firebase_chating_app/screens/login_screen.dart';
import 'package:firebase_chating_app/screens/registration_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation curveanimation;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      // upperBound: 1
    );

    //This  color animation
    animation=ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    curveanimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    //what animation do we want to apply the curve to and what type of curve
    // curveanimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // controller.forward();

    // //to check the status of our animation and make it go back and forth
    // animation.addStatusListener((status) {
    //   if(status==AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    //dispose the animation when moved to the next page
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: curveanimation.value*60,
                    //height: animation.value * 60,  //this animation is for curve movement
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: "Log in", color: Colors.lightGreen, onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(title: "Register", color: Colors.blueAccent, onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}

