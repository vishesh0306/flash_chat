
import 'package:flash/components/rounded_button.dart';
import 'package:flash/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  SpinKitCubeGrid isloading = SpinKitCubeGrid(
    size: 140,
    color: Colors.white,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
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
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
              ),
              SizedBox(
                height: 8.0,
              ),

              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
              ),

              SizedBox(
                height: 24.0,
              ),

              // AsyncButtonBuilder(
              //   child: Text('Click Me'),
              //   onPressed: () async {
              //     await Future.delayed(Duration(seconds: 1));
              //     try{
              //       final user = await _auth.signInWithEmailAndPassword(email: email, password: password.toString());
              //       if(user!=null){
              //         Navigator.pushNamed(context, ChatScreen.id);
              //       }
              //     }
              //     catch(e){
              //       print(e);
              //     }
              //   },
              //   builder: (context, child, callback, _) {
              //     return ;
              //   }),

              RoundedButton(
                  Colors.lightBlueAccent,
                  'Log In',
                      ()async{
                    setState(() {
                      showspinner = true;
                    });

                    try{
                    await _auth.signInWithEmailAndPassword(email: email, password: password.toString());
                    Navigator.pushNamed(context, ChatScreen.id);

                                      setState(() {
                      showspinner = false;
                    });
                      }
                      catch(e){
                      print(e);
                      }
                  }

              ),

            ],
          ),
        ),
      ),
    );
  }
}