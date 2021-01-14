import 'package:flutter/material.dart';
import 'package:news_app/models/users.dart';

import 'app_utils.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: "NewsApp",
    home: Login(),
    theme: ThemeData(primaryColor: getAppThemeColor()),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldStateKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldStateKey,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        child: Form(
            key: _loginFormKey,
            child: ListView(shrinkWrap: true, children: [
              Image(
                  width: 100,
                  height: 100,
                  image: AssetImage("assets/ic_news.png")),
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
                validator: (emailValue) {
                  if (emailValue.isEmpty) return "Enter a valid email";
                  return null;
                },
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
                          color: Colors.grey,
                        ),
                        onPressed: _showPassword),
                    labelText: "Password",
                    hintText: "Enter password"),
                validator: (value) {
                  return _validatePassword(value);
                },
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12), primary: getAppThemeColor()),
                  child: getCommonText("Login"),
                  onPressed: () {
                    if (_loginFormKey.currentState.validate()) {
                      _loginUser(_emailTextEditingController.text,
                          _passwordTextEditingController.text);
                    }
                  },
                ),
              ),
            ])),
      ),
    );
  }

  void _showPassword() {
    setState(() {
      _passwordShown = !_passwordShown;
    });
  }

  void _loginUser(String email, String password) {
    final user = getUsers().singleWhere(
        (element) => element.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () => null);
    if (user == null) {
      showOkAlert(context, "Error", "User not found");
      return;
    }
    if (user.password != password) {
      showOkAlert(context, "Error", "Password incorrect");
      return;
    }
    _pushHome();
  }

  void _pushHome() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return Home();
    }));
  }

  String _validatePassword(passwordValue) {
    if (passwordValue.isEmpty) {
      return "Enter a password";
    } else if (passwordValue.length < 5) {
      return "Password should be at least 5 characters long";
    }
    return null;
  }
}
