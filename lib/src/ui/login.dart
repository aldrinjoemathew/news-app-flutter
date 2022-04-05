import 'package:flutter/material.dart';
import 'package:news_app/src/repositories/user_repo.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/login_validation.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../models/users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final _loginFormKey = GlobalKey<FormState>();
  final _loginFontStyle = TextStyle(fontSize: 16);
  var _passwordShown = false;
  late LoginValidation _validationService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _validationService = Provider.of<LoginValidation>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        child: ListView(shrinkWrap: true, children: [
          _getLoginLogo(),
          Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
          TextField(
            autofocus: false,
            style: _loginFontStyle,
            keyboardType: TextInputType.emailAddress,
            onChanged: _validationService.changeEmailId,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter email",
              errorText: _validationService.emailId.error,
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
          TextField(
            autofocus: false,
            style: _loginFontStyle,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _passwordShown ? false : true,
            onChanged: _validationService.changePassword,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordShown ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _showPassword),
                labelText: "Password",
                hintText: "Enter password",
                errorText: _validationService.password.error),
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
        ]),
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

  void _loginUser(String? email, String? password) async {
    if (_loading) return;
    setLoading(true);
    email = email?.trim().toLowerCase();
    User? user = UserRepo().getUsers().firstWhereOrNull(
        (element) => element.email.toLowerCase() == email);
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
    Navigator.of(context).pushReplacementNamed(AppRoutes.Home);
  }

  Widget _getLoginLogo() {
    return Image(
        width: 100, height: 100, image: AssetImage("assets/ic_news.png"));
  }

  void _pushPasswordResetPage() {
    print("Reset password page");
  }

  Widget _getLoginBtn() {
    final List<Widget> stackChildren = [
      SizedBox(
        width: double.infinity,
        child: getAppFlatBtn(
          "Log in",
          _validationService.isValid()
              ? () {
                  _validationService.submitForm();
                  _loginUser(
                    _validationService.emailId.value,
                    _validationService.password.value,
                  );
                }
              : null,
        ),
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
