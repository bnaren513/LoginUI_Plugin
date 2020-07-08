import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginscreenkt/loginscreenkt.dart';


void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen1State createState() => new _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginScreen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '\home')
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text("Home")),
            ),
          );

        return MaterialPageRoute(
          builder: (context) => Loginscreenkt(
           backgroundColor: Colors.blue.shade600,
          //  background: Container
          //  (child: Image.asset('assets/splash.jpeg',
          //    fit: BoxFit.cover),),
            showErrortext : false,
           // asset: 'assets/apple.png',
            authenticator: (login, pass) {
              print(login);
              print(pass);
              return true;
            },
            nextRoute: '\home',
            rememberOption: true,
            onRemember: (_) => print('remember'),
            duration: 3000,
          ),
        );
      },
    );
  }
}
