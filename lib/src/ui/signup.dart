import 'package:flutter/material.dart';
import 'package:news_app/src/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../repositories/user_repo.dart';
import '../utils/app_theme_utils.dart';
import '../utils/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _userRepo = UserRepo();
  final _formKey = GlobalKey<FormState>();
  var _passwordVisible = false;
  bool _loading = false;

  var _name;
  var _email;
  var _password;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: 100,
                    height: 100,
                    image: AssetImage("assets/ic_news.png"),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                    ),
                    validator: (String? value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : 'Please enter a name',
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => _name = value,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                    ),
                    validator: (String? value) => value?.isValidEmail() == true
                        ? null
                        : 'Enter a valid email',
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      labelText: "Password",
                      hintText: "Enter password",
                    ),
                    validator: (String? value) =>
                        value != null && value.isNotEmpty == true
                            ? null
                            : 'Enter a password',
                    textInputAction: TextInputAction.done,
                    onSaved: (value) => _password = value,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 32, 0, 0)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            "Cancel",
                            style:
                                TextStyle(color: AppColors.white, fontSize: 16),
                          ),
                          onPressed: _backToLogin,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: _loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 3.0,
                                  ))
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: AppColors.white, fontSize: 16),
                                ),
                          onPressed: () {
                            if (_loading) {
                              //Do nothing
                            } else if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              login(_name, _email, _password);
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void setLoading(bool isLoading) {
    setState(() {
      _loading = isLoading;
    });
  }

  void login(name, email, password) async {
    var user = await _userRepo.addUser(name, email, password);
    if (user != null) {
      context.read<UserModel>().updateUserDetails(user);
      _pushHomePage();
    } else {}
  }

  void _pushHomePage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.Home, (route) => false);
  }

  void _backToLogin() {
    Navigator.of(context).pop();
  }
}
