import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool loginMode,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (loginMode) {
        //login user
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        //register user
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //upload user image
        if (image != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(authResult.user!.uid + '.jpg');
          storageRef.putFile(image);
        }
        //in order to get url of uploaded image, whole process must be put in function that returns Future (example on pub dev firebase_storage)
        String url = '';
        // url = await storageRef.getDownloadURL();

        //Save extra user data to firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (error) {
      String message = 'An error occurred. Please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      //doesnt work with either context
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(message),
      // ));
      print(message);
    } catch (error) {
      //other type of errors, just in case to see while developing
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
