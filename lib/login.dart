import 'package:flutter/material.dart';
import 'package:news_app/models/users.dart';
import 'package:news_app/utils/app_theme_utils.dart';

import 'home.dart';
import 'utils/app_utils.dart';
import 'utils/validation_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final _loginFormKey = GlobalKey<FormState>();
  final _loginFontStyle = TextStyle(fontSize: 16);
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  var _passwordShown = false;

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        child: Form(
            key: _loginFormKey,
            child: ListView(shrinkWrap: true, children: [
              _getLoginLogo(),
              Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
              TextFormField(
                autofocus: false,
                controller: _emailTextEditingController,
                style: _loginFontStyle,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter email",
                ),
                validator: validateEmail,
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
              TextFormField(
                autofocus: false,
                controller: _passwordTextEditingController,
                style: _loginFontStyle,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passwordShown ? false : true,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _passwordShown
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _showPassword),
                    labelText: "Password",
                    hintText: "Enter password"),
                validator: validatePassword,
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
              _getLoginBtn(),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                child: Text(
                  "Forgot password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
                onTap: _pushPasswordResetPage,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Don't have an account? Sign up",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              )
            ])),
      ),
    );
  }

  void _showPassword() {
    setState(() {
      _passwordShown = !_passwordShown;
    });
  }

  void setLoading(bool isLoading) {
    setState(() {
      _loading = isLoading;
    });
  }

  void _loginUser(String email, String password) async {
    if (_loading) return;
    setLoading(true);
    email = email.trim().toLowerCase();
    final user = getUsers().firstWhere(
        (element) => element.email.toLowerCase() == email,
        orElse: () => null);
    if (user == null) {
      showOkAlert(context, "Error", "User not found");
      setLoading(false);
      return;
    }
    if (user.password != password) {
      showOkAlert(context, "Error", "Password incorrect");
      setLoading(false);
      return;
    }
    saveLoggedInUser(user);
    await Future.delayed(Duration(seconds: 3));
    setLoading(false);
    _pushHomePage();
  }

  void _pushHomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return HomePage();
    }));
  }

  Widget _getLoginLogo() {
    return Image(
        width: 100, height: 100, image: AssetImage("assets/ic_news.png"));
  }

  void _pushPasswordResetPage() {
    print("Reset password page");
  }

  void _onPressLoginBtn() {
    if (_loginFormKey.currentState.validate()) {
      _loginUser(_emailTextEditingController.text,
          _passwordTextEditingController.text);
    }
  }

  Widget _getLoginBtn() {
    final List<Widget> stackChildren = [
      SizedBox(
        width: double.infinity,
        child: getAppFlatBtn("Log in", _onPressLoginBtn),
      )
    ];
    if (_loading) {
      stackChildren.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(6),
        child: CircularProgressIndicator(),
      ));
    }
    return Stack(children: stackChildren);
  }
}
