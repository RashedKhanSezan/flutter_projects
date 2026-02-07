import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatting_app/widgets/userimagepicker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isAuthenticating = false;
  bool _isLogin = true;
  var _email = '';
  var _password = '';
  var _userName = '';
  File? _selectedImage;
  final _myFromKey = GlobalKey<FormState>();

  void _submitted() async {
    final isValid = _myFromKey.currentState!.validate();

    if (!isValid) {
      //login mode
      return;
    }
    if (!_isLogin && _selectedImage == null) {
      //signup mode
      return;
    }
    _myFromKey.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await firebase.signInWithEmailAndPassword(
            email: _email, password: _password);
        print(userCredentials);
      } else {
        setState(() {
          _isAuthenticating = true;
        });
        final userCredentials = await firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child('${userCredentials.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'userName': _userName,
          'email': _email,
          'image_Url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      e.message;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed.')));
      if (e.code == 'email-already-in-use') {
        // ...
      }
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  right: 20,
                  left: 20,
                  bottom: 10,
                ),
                width: 220,
                child: Image.asset('assets/images/chat01.png'),
              ),
              Card(
                color: Theme.of(context).colorScheme.onPrimary,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _myFromKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin)
                          UserImagePicker(
                            onPickedImage: (fileFromImagePicker) {
                              _selectedImage = fileFromImagePicker;
                            },
                          ),
                        if (!_isLogin)
                          TextFormField(
                            decoration:
                                InputDecoration(label: Text('Username')),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length > 4) {
                                return;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _userName = newValue!;
                            },
                          ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter Your Email'),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _email = newValue!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter Your Password'),
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 character';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        !_isAuthenticating
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: _submitted,
                                child: Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              )
                            : CircularProgressIndicator(),
                        if (_isAuthenticating != true)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create New Account'
                                : 'Already have an account'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
