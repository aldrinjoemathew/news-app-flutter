import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:news_app/src/models/user_model.dart';
import 'package:news_app/src/models/users.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/edit_profile_validation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _dobEditingController = TextEditingController();
  User _user;
  bool _saving = false;
  ImagePicker _imagePicker;
  File _profileImageFile;
  EditProfileValidation _validationService;
  FocusNode _dobFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _imagePicker = ImagePicker();
    _dobFocusNode.addListener(_onDobFocused);
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    _validationService = Provider.of<EditProfileValidation>(context);
    final profileImage = _profileImageFile != null
        ? Image.file(
            _profileImageFile,
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          )
        : Image.asset(
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
            onPressed: () {
              _pickImage();
            },
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
    listChildren.add(TextField(
      controller: _nameEditingController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      onChanged: _validationService.changeName,
      decoration: InputDecoration(
          errorText: _validationService.name.error,
          hintText: "Enter your full name",
          labelText: "Full Name"),
    ));
    listChildren.add(TextFormField(
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
      onChanged: _validationService.changeEmailId,
      decoration: InputDecoration(
          errorText: _validationService.emailId.error,
          hintText: "Enter your email ID",
          labelText: "Email ID"),
    ));
    listChildren.add(TextFormField(
      readOnly: true,
      controller: _dobEditingController,
      focusNode: _dobFocusNode,
      enabled: true,
      keyboardType: null,
      decoration: InputDecoration(
          errorText: _validationService.dob.error,
          hintText: "yyyy-MM-dd",
          labelText: "Date of Birth"),
    ));
    final saveBtn = getAppFlatBtn(
      "Save",
      _saving || !_validationService.isValid() ? null : _onClickSave,
      disabledBtnColor: AppColors.green.withOpacity(0.5),
      btnColor: AppColors.green,
    );
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
      child: ListView(
        children: listChildren,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: body,
      backgroundColor: AppColors.beige,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameEditingController.dispose();
    _emailEditingController.dispose();
  }

  void _onClickSave() async {
    setState(() {
      _saving = true;
    });
    _validationService.submitForm();
    _user.name = _validationService.name.value;
    _user.email = _validationService.emailId.value;
    _user.dob = _validationService.dob.value;
    bool saved = await _updateUserDetailsInPref(_user);
    if (saved) {
      context.read<UserModel>().updateUserDetails(_user);
    }
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _saving = false;
    });
    _popRoute();
  }

  void _onClickCancel() {
    _popRoute();
  }

  void _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = userFromJson(prefs.getString("user"));
    setState(() {
      _user = user;
      _nameEditingController.text = _user?.name;
      _emailEditingController.text = _user?.email;
      _dobEditingController.text = _user?.dob;
      _validationService.setInitialValues(
          name: _user.name, email: _user.email, dob: _user.dob);
      if (user?.profileImagePath?.isNotEmpty == true) {
        _profileImageFile = File(user.profileImagePath);
      }
    });
  }

  Future<bool> _updateUserDetailsInPref(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString("user", userToJson(user));
    if (saved) {
      print("saved");
    }
    return saved;
  }

  void _popRoute() {
    Navigator.of(context).pop();
  }

  Future _pickImage() async {
    final imageFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (imageFile.path?.isNotEmpty == true) {
      _user.profileImagePath = imageFile.path;
      print("ImagePicker: Image path: ${imageFile.path}");
      setState(() {
        _profileImageFile = File(_user.profileImagePath);
      });
    } else {
      print("ImagePicker: Error getting image path");
      showOkAlert(context, "Error", "Unable to select the image");
    }
  }

  void _openDatePicker() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now());
    final dateString = DateFormat(DateFormats.DateOfBirth).format(selectedDate);
    print("Selected date: $dateString");
    _validationService.changeDob(dateString);
    if (dateString?.isNotEmpty == true) {
      setState(() {
        _dobEditingController.text = dateString;
      });
    }
  }

  void _onDobFocused() {
    if (_dobFocusNode.hasFocus) {
      _openDatePicker();
      _dobFocusNode.unfocus();
    }
  }
}
