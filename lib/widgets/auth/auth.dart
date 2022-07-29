import 'dart:io';
import 'package:chat_app/widgets/pickers/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  void Function({
    required String email,
    required String userName,
    required String password,
    required bool isLogin,
    required File? image,
    required BuildContext ctx,
  }) submitAuthForm;
  final bool isLoading;
  AuthForm({Key? key, required this.submitAuthForm, required this.isLoading})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _password = '';
  String _userName = '';
  var _isLogin = true;
  File? userImageFile;

  void pickedImage(File image) {
    userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    if (!_isLogin && userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }
    _formKey.currentState!.save();
    widget.submitAuthForm(
      email: _userEmail.trim(),
      password: _password.trim(),
      userName: _userName.trim(),
      isLogin: _isLogin,
      image: userImageFile,
      ctx: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin)
                      UserImagePicker(
                        imagePickFn: pickedImage,
                      ),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Enter a valid email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }
                        return 'Enter a valid email';
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _userEmail = value;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    if (!_isLogin)
                      const SizedBox(
                        height: 20,
                      ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('Username'),
                        autocorrect: false,
                        autofocus: true,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          }
                          return 'Enter a valid username';
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _userName = value;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Username',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: const ValueKey('Password'),
                      autocorrect: false,
                      autofocus: true,
                      obscureText: true,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Password is too short';
                          }
                          return null;
                        }
                        return 'Please enter a valid password';
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _password = value;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Not Registered? Click Here'
                              : 'Login View',
                        ),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
