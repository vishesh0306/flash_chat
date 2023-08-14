import 'package:flutter/material.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flash/screens/login_screen.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flash/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen' :(context)=>WelcomeScreen(),
        'login_screen': (context)=>LoginScreen(),
        'registration_screen':(context)=>RegistrationScreen(),
        'chat_screen':(context)=>ChatScreen(),

      },
    );
  }
}