import 'dart:io';

import 'package:chat_app/utilities/fcm_helper.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm({
    String email,
    String username,
    String password,
    File userPickedImage,
    bool isLogin,
  }) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final userId = authResult.user.uid;
        final userImageUploader = FirebaseStorage.instance
            .ref()
            .child('user-image')
            .child('$userId.jpg');
        await userImageUploader.putFile(userPickedImage).onComplete;
        await Firestore.instance.collection('users').document(userId).setData(
          {
            'username': username,
            'email': email,
            'image_url': await userImageUploader.getDownloadURL(),
            'fcm_token': await FcmHelper.getFirebaseToken(),
          },
        );
      }
    } on PlatformException catch (err) {
      var message = 'an error occured, please check your credential';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return authResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AuthForm(
          submitAuthForm: _submitAuthForm,
          isFormLoading: _isLoading,
        ),
      ),
    );
  }
}
