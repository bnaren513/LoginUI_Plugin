import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Loginscreenkt extends StatefulWidget {
  Loginscreenkt(
      {Key key,
      this.backgroundColor,
      this.cardColor,
      this.background,
      @required this.authenticator,
      this.loginValidator,
      this.passwordValidator,
      this.duration,
      this.buttonContent,
      this.buttonColor,
      this.buttonTextColor,
      this.nextRoute,
      this.loginLabelText,
      this.loginHintText,
      this.passwordLabelText,
      this.passwordHintText,
      this.authenticationErrorMessage = "authentication failed.",
      this.passwordErrorMessage = "password failed.",
      this.loginErrorMessage = "login failed.",
      this.asset,
      this.rememberOption = false,
      this.onRemember,
      this.rememberText,
      this.createAccount = false,
      this.accountRoute,
      this.passwordVisibilityToggable = true,
      this.loginKeyboard = TextInputType.emailAddress,
      this.passwordKeyboard = TextInputType.visiblePassword,
      //this.showLoginErrorMessage,
      //this.showPasswordErrorMessage,
      this.showErrortext
      //this.loginbuttonAction,
      })
      : assert(authenticator != null),
        assert(nextRoute != null && nextRoute.isNotEmpty),
        assert(!createAccount ||
            (createAccount && accountRoute != null && accountRoute.isNotEmpty)),
        assert(!rememberOption || (rememberOption && onRemember != null)),
        super(key: key);

  // Function loginbuttonAction;

// UI Options

  /// Screen's background color. If this parameter is not null, [background] must be null.
  final Color backgroundColor;

  //  bool showLoginErrorMessage;
  //  bool showPasswordErrorMessage;
  bool showErrortext;

  /// Card's color. If null, the theme's default will be used.
  final Color cardColor;

  /// Screen's background Widget. If this parameter is not null, [backgroundColor] must be null.
  final Widget background;

  /// Whether password has a `toggle visibility` button. Defaults to true.
  final bool passwordVisibilityToggable;

  /// Fade animation duration in milliseconds. Defaults to 450.
  final int duration;

  /// If true, creates a link under the login button for account creation. Defaults to false
  final bool createAccount;

  /// Whether to add a `Remember me` checkbox. Defaults to false.
  /// This is only a visual checkbox and the funcion should be provided in
  /// [onRemember].
  final bool rememberOption;

  /// An Image to show above the login fields.
  final String asset;

  /// RaisedButton's child. Usually a [Text].
  final Widget buttonContent;

  /// Login Button Color. Defaults to blue.
  final Color buttonColor;

  /// Button's textColor. Defaults to white.
  final Color buttonTextColor;

  /// Login's field label text
  final String loginLabelText;

  /// Login's field hint text
  final String loginHintText;

  /// Password's field label text
  final String passwordLabelText;

  /// Password's field hint text
  final String passwordHintText;

  /// Text to show in remember checkbox. Defaults to 'Keep me logged in'
  final String rememberText;

// Fields' Options

  /// Keyboard type for login field.
  final TextInputType loginKeyboard;

  /// Keyboard type for password field.
  final TextInputType passwordKeyboard;

  final String authenticationErrorMessage;
  final String passwordErrorMessage;
  final String loginErrorMessage;

// Callbacks

  /// Function called when login button is pressed.
  final FutureOr<bool> Function(String, String) authenticator;

  /// Validator callback for login. Defaults to:
  ///   -  Must not be null or empty
  ///   -  Must be formatted like an email. (email@example.com)
  final bool Function(String) loginValidator;

  /// Validator callback for password. Defaults to:
  ///   -  Length >= 6 And <= 20
  ///   -  Must contain at least 1 digit and 1 letter
  final bool Function(String) passwordValidator;

  /// Remember me Callback. Must be informed if [rememberOption] is true.
  final FutureOr<void> Function(bool) onRemember;

// -- Routing Options  ------------------------------------------------------------------

  /// Next Route's name to be inserted in [Navigator.pushNamed(context, routeName)].
  /// Must not be null
  final String nextRoute;

  /// Route Name to use in [Navigator.pushNamed(context, routeName)].
  /// Must be informed if [createAccount] is true.
  final String accountRoute;

  @override
  _LoginscreenktState createState() => _LoginscreenktState();
}

class _LoginscreenktState extends State<Loginscreenkt> {
  double _opacity;
  bool obscure = true;

  String login;
  String password;

  bool remember = false;

  bool showAuthenticationErrorMessage = false;
  //bool showPasswordErrorMessage = false;
  // bool showLoginErrorMessage = false;

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
  void initState() {
    super.initState();
    _opacity = 0.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    showAuthenticationErrorMessage = false;
    //showPasswordErrorMessage = false;
    // widget.showLoginErrorMessage = false;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: widget.background ?? Container(),
          ),
          Center(
            child: AnimatedOpacity(
              duration: widget.duration != null
                  ? Duration(milliseconds: widget.duration)
                  : Duration.zero,
              opacity: _opacity,
              curve: Curves.easeIn,
              child: Card(
                elevation: widget.background != null ? 4.0 : 16.0,
                margin: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: widget.cardColor,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(maxWidth: 550),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        widget.asset != null
                            ? ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 216),
                                child: FittedBox(
                                  child: Image.asset(widget.asset),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        widget.showErrortext
                            ? SizedBox(height: 0)
                            : (loginErrormessge || passwordErrormessge)
                                ? IndividualErrorContainer(
                                    errorMsg: loginErrormessge
                                        ? (loginMessage ?? "")
                                        : (passwordMessage ?? ""),
                                    color: widget.backgroundColor)
                                : SizedBox(height: 0),
                        const SizedBox(height: 20),
                        TextField(
                            keyboardType: widget.loginKeyboard,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: widget.loginHintText,
                              labelText: widget.loginLabelText ?? 'Login',
                              errorText: widget.showErrortext
                                  ? (loginErrormessge
                                      ? loginMessage ?? ""
                                      : null)
                                  : null,
                              errorMaxLines: 10,
                            ),
                            onChanged: (value) {
                              setState(() {
                                login = value;
                              });
                              validateEmail(value);
                            }),
                        const SizedBox(height: 12.0),
                        TextField(
                            keyboardType: widget.passwordKeyboard,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              hintText: widget.passwordHintText,
                              labelText: widget.passwordLabelText ?? 'Password',
                              errorText: widget.showErrortext
                                  ? (passwordErrormessge
                                      ? passwordMessage ?? ""
                                      : null)
                                  : null,
                              errorMaxLines: 10,
                              suffix: widget.passwordVisibilityToggable
                                  ? IconButton(
                                      icon: Icon(obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () =>
                                          setState(() => obscure = !obscure),
                                    )
                                  : null,
                            ),
                            obscureText: widget.passwordVisibilityToggable
                                ? obscure
                                : true,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                              validatePassword(value);
                              // widget.passwordValidator(value);
                            }),
                        const SizedBox(height: 4.0),
                        widget.rememberOption
                            ? ListTile(
                                leading: Icon(
                                  remember
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: remember ? Colors.green : Colors.grey,
                                ),
                                title: Text(
                                    widget.rememberText ?? 'Keep me logged in'),
                                onTap: () =>
                                    setState(() => remember = !remember),
                              )
                            : Container(),
                        const SizedBox(height: 8.0),
                        showAuthenticationErrorMessage
                            ? Text(
                                widget.passwordErrorMessage ?? "",
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        const SizedBox(height: 12.0),
                        Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: widget.buttonColor ?? Colors.blue,
                            textColor: widget.buttonTextColor ?? Colors.white,
                            child: widget.buttonContent ?? Text("Login"),
                            onPressed: tryLogin,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryLogin() async {
    var result = false;

    if (validateEmail(login) && validatePassword(password)) {
      result = await widget.authenticator(login, password);

      if (result) {
        if (widget.rememberOption ?? false) {
          await widget.onRemember(remember);
        }

       // Navigator.of(context).pushReplacementNamed(widget.nextRoute);
      }
    }
  }
}

class IndividualErrorContainer extends StatelessWidget {
  final String errorMsg;
  final Color color;

  IndividualErrorContainer({
    this.errorMsg,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return errorPopup(context);
  }

  Widget errorPopup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 10.0,

          //maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            alignment: Alignment.bottomLeft,
            decoration: new BoxDecoration(
                color: color, borderRadius: new BorderRadius.circular(15)),
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minWidth: 20,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 5, bottom: 5, right: 15),
                child: Text(
                  errorMsg,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    //fontFamily: Util.CustomFont
                  ),
                  maxLines: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
