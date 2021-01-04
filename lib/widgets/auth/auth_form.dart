import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function({
    String email,
    String username,
    String password,
    File userPickedImage,
    bool isLogin,
  }) submitAuthForm;
  final bool isFormLoading;

  const AuthForm({
    Key key,
    @required this.submitAuthForm,
    @required this.isFormLoading,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginForm = true;
  var _email = '';
  var _username = '';
  var _password = '';
  File _userImage;

  void _onPickedImage(File pickedImage) {
    _userImage = pickedImage;
  }

  void _submitForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLoginForm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      widget.submitAuthForm(
          email: _email.trim(),
          username: _username.trim(),
          password: _password.trim(),
          isLogin: _isLoginForm,
          userPickedImage: _userImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLoginForm)
                  UserImagePicker(
                    onPickedImage: _onPickedImage,
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  onSaved: (newValue) => _email = newValue,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                if (!_isLoginForm)
                  TextFormField(
                    key: ValueKey('username'),
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    onSaved: (newValue) => _username = newValue,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Please enter at least 5 characters';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _password = newValue,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.isFormLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!widget.isFormLoading)
                  RaisedButton(
                    child: Text(_isLoginForm ? 'Login' : 'Signup'),
                    onPressed: _submitForm,
                  ),
                if (!widget.isFormLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      _isLoginForm
                          ? 'Create new account'
                          : 'I already have an account',
                    ),
                    onPressed: () => setState(() {
                      _isLoginForm = !_isLoginForm;
                    }),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
