import 'package:flutter/material.dart';
import 'package:news_app/utils/app_theme_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/users.dart';
import 'utils/validation_utils.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User _user;
  bool _saving = false;

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = Image.asset(
      "assets/ic_profile_dummy.png",
      width: 150,
      height: 150,
      fit: BoxFit.fill,
    );
    final imageStack = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        profileImage,
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: FlatButton(
            height: 48,
            color: Colors.black.withOpacity(0.5),
            child: Text(
              "Change image",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        )
      ],
    );
    final imageParent = Container(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(32)),
        child: imageStack,
      ),
    );
    final List<Widget> listChildren = [
      SizedBox(height: 50),
      imageParent,
    ];

    listChildren.add(SizedBox(height: 8));
    _nameEditingController.text = _user?.name;
    _emailEditingController.text = _user?.email;
    listChildren.add(TextFormField(
      controller: _nameEditingController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          hintText: "Enter your full name", labelText: "Full Name"),
      validator: validateText,
    ));
    listChildren.add(TextFormField(
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: "Enter your email ID", labelText: "Email ID"),
      validator: validateEmail,
    ));
    final saveBtn = getAppFlatBtn("Save", _saving ? null : _onClickSave,
        btnColor: AppColors.green);
    final saveBtnWithLoader = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(width: double.infinity, child: saveBtn),
        CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(AppColors.green),
        )
      ],
    );
    listChildren.add(Container(
      padding: EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: getAppFlatBtn("Cancel", _saving ? null : _onClickCancel,
                  btnColor: AppColors.red)),
          SizedBox(width: 16),
          Expanded(
            child: _saving ? saveBtnWithLoader : saveBtn,
          ),
        ],
      ),
    ));
    final body = Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Form(
          key: _formKey,
          child: ListView(
            children: listChildren,
          )),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: body,
    );
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    super.dispose();
  }

  void _onClickSave() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _saving = true;
      });
      _user.name = _nameEditingController.text;
      _user.email = _emailEditingController.text;
      await _updateUserDetailsInPref(_user);
      setState(() {
        _saving = false;
      });
      _popRoute();
    }
  }

  void _onClickCancel() {
    _popRoute();
  }

  void _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = userFromJson(prefs.getString("user"));
    setState(() {
      _user = user;
    });
  }

  Future<bool> _updateUserDetailsInPref(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("user", userToJson(user));
  }

  void _popRoute() {
    Navigator.of(context).pop();
  }
}
