import 'dart:io';

import 'package:chatterbeings/component/component.dart';
import 'package:chatterbeings/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLogin = true;
  File? _image = null;
  String imageUrl = '';
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void auth(ctx) async {
    UserCredential userCredential;
    String authMessages = '';
    if (!isLogin) {
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passController.text);

        var ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(_image!);
        print('uploading ..............................');
        imageUrl = await ref.getDownloadURL();
        print(imageUrl);
        FirebaseFirestore.instance
            .collection('users/')
            .doc(userCredential.user?.uid)
            .set({
          'password': passController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'imageUrl': imageUrl
        });
      } on FirebaseAuthException catch (e) {
        showCustomisedAlertDialog(context,
            exception: e, title: 'filed to register');
      }
    } else {
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text);
        FirebaseFirestore.instance
            .collection('users/')
            .doc(userCredential.user?.uid)
            .set({
          'password': passController.text,
          'email': emailController.text,
        });
      } on FirebaseAuthException catch (e) {
        showCustomisedAlertDialog(context,
            exception: e, title: 'filed to login');
      }
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Container(
          height: (!isLogin) ? 485 : 345,
          width: MediaQuery.of(context).size.width * .75,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 30, right: 15, left: 15),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (!isLogin)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                _image != null ? FileImage(_image!) : null,
                          ),
                          OutlinedButton.icon(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.image),
                              label: Text('pick from gallery')),
                        ],
                      ),
                    if (!isLogin)
                      const SizedBox(
                        height: 10,
                      ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (vVali) {
                        if (vVali!.isEmpty)
                          return 'please enter a valid email';
                        else
                          return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'mail',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (!isLogin)
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (vVali) {
                          if (vVali!.isEmpty)
                            return 'please enter a valid user';
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'user name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (!isLogin)
                      const SizedBox(
                        height: 15,
                      ),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      validator: (Vali) {
                        if (Vali!.isEmpty)
                          return 'please enter a valid password';
                        else
                          return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'password',
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .75,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if(formKey.currentState!.validate())
                              auth(context);
                            });
                          },
                          child: Text(isLogin ? 'Sign In' : 'register'),
                        ),
                      ),
                     const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                            _image = null;
                            passController.text = '';
                            emailController.text = '';
                            usernameController.text = '';
                            formKey = GlobalKey<FormState>();
                          });
                        },
                        child: Text(isLogin?'Already have an account?':'create an account'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
