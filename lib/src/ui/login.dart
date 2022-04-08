import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/repositories/user_repo.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/login_validation.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../utils/app_theme_utils.dart';

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
  final _passwordFocusNode = FocusNode();
  final _submitBtnFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _validationService = Provider.of<LoginValidation>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        child: ListView(shrinkWrap: true, children: [
          Image(
            width: 100,
            height: 100,
            image: AssetImage("assets/ic_news.png"),
          ),
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
            textInputAction: TextInputAction.next,
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
              errorText: _validationService.password.error,
            ),
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocusNode,
            onSubmitted: (_) {
              _passwordFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_submitBtnFocusNode);
            },
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
          ElevatedButton(
            focusNode: _submitBtnFocusNode,
            child: _loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 3.0,
                    ))
                : Text(
                    "Log in",
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
            onPressed: _validationService.isValid()
                ? () {
                    if (_loading) {
                      //Do nothing
                    } else {
                      _validationService.submitForm();
                      _loginUser(
                        _validationService.emailId.value,
                        _validationService.password.value,
                      );
                    }
                  }
                : null,
          ),
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
    await Future.delayed(Duration(seconds: 2));
    email = email?.trim().toLowerCase();
    User? user = UserRepo()
        .getUsers()
        .firstWhereOrNull((element) => element.email.toLowerCase() == email);
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
    context.read<UserModel>().updateUserDetails(user);
    await Future.delayed(Duration(seconds: 3));
    setLoading(false);
    _pushHomePage();
  }

  void _pushHomePage() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.Home);
  }

  void _pushPasswordResetPage() {
    print("Reset password page");
  }
}
