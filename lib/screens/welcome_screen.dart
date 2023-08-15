import 'package:flash/components/rounded_button.dart';
import 'package:flash/screens/login_screen.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 1) , vsync: this);
    animation = ColorTween(begin: Colors.white,end: Colors.blueGrey).animate(controller as Animation<double>);

  controller?.forward();
  controller?.addListener(() {
    setState(() {});
  });
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation?.value,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: (controller!.value*90),
                ),
              ),

              AnimatedTextKit(
                animatedTexts: [TypewriterAnimatedText('Flash Chat',
              textStyle: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w900,

              ),speed: Duration(milliseconds: 400)
              )

              ],
              ),
            ],
          ),
          SizedBox(
            height: 28.0,
          ),


          RoundedButton(
              Colors.lightBlueAccent,
              'Log In',
                  (){Navigator.pushNamed(context, LoginScreen.id);},


          ),


          RoundedButton(
              Colors.blueAccent,
              'Register',
                  (){Navigator.pushNamed(context, RegistrationScreen.id);}

          ),

        ],
      ),
    );
  }
}