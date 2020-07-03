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
  String loginMessage = '';
  String passwordMessage = '';
  bool loginErrormessge = false;
  bool passwordErrormessge = false;
  bool validateEmail(String value) {
    bool emailValid = false;
    String message = '';
    if (value == '' || value == null) {
      emailValid = false;
    } else {
      emailValid =
          RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    }
    if (value == '' || value == null) {
      message = 'Please enter email';
    } else if (!emailValid) {
      message = 'Please enter a valid email';
    } else {
      message = '';
    }

    setState(() {
      loginMessage = message;
      loginErrormessge = !emailValid;
    });
    return emailValid;
  }

  bool validatePassword(String value) {
    bool passwordvalid = false;
    String message = '';
    if (value == '' || value == null) {
      passwordvalid = false;
    } else {
      Pattern pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@^%#\$&*~(){}<>?:;.,\W_=+-]).{8,}$';
      RegExp regex = new RegExp(pattern);
      passwordvalid = regex.hasMatch(value);
    }
    if (value == '' || value == null) {
      message = 'Please enter password';
    } else if (!passwordvalid) {
      message =
          'Password must have at least one capital letter,number and special character';
    } else {
      message = '';
    }
    setState(() {
      passwordMessage = message;
      passwordErrormessge = !passwordvalid;
    });
    return passwordvalid;
  }

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
            loginErrorMessage: loginMessage,
            passwordErrorMessage: passwordMessage,
            authenticator: (login, pass) {
              print(login);
              print(pass);
              if (validateEmail(login) && validatePassword(pass)) {
                setState(() {
                  loginErrormessge = false;
                  passwordErrormessge = false;
                });
                return true;
              } else if (!validateEmail(login)) {
                setState(() {
                  loginErrormessge = true;
                });
                return true;
              } else if (!validatePassword(pass)) {
                setState(() {
                  loginErrormessge = false;
                  passwordErrormessge = true;
                });
                return true;
              }

              return false;
            },
//             loginbuttonAction: (_){
// print('login action');
//             },
            nextRoute: '\home',
            rememberOption: true,
            onRemember: (_) => print('remember'),
            duration: 1250,
            showLoginErrorMessage: loginErrormessge,
            showPasswordErrorMessage: passwordErrormessge,
            loginValidator: (login) {
              return validateEmail(login);
            },
            passwordValidator: (password) {
              return validatePassword(password);
            },

            // loginValidator: (login)
            // {
            //   setState(() {
            //     loginErrormessge = true;
            //   });

            //   print (login);
            //   return validateEmail(login);
            // },
            // passwordValidator:(password)
            // {
            //   print (password);
            //   return validateEmail(password);
            // },
          ),
        );
      },
    );
  }
}
