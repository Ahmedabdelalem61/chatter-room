import 'dart:io';

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
  String email = '';
  String username = '';
  String pass = '';
  bool isLogin = true;
  File? _image = null;
  String imageUrl = '';
  final picker = ImagePicker();


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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
            .createUserWithEmailAndPassword(email: email, password: pass);

        var ref = FirebaseStorage.instance.ref()
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
          'password': pass,
          'username': username,
          'email': email,
          'imageUrl':imageUrl
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          authMessages = e.code;
          print('The password provided is too weak.');
          authMessages = e.code;
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          authMessages = e.code;
        }
      } catch (e) {
        print(e);
        authMessages = e.toString();
      }
    } else {
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
        FirebaseFirestore.instance
            .collection('users/')
            .doc(userCredential.user?.uid)
            .set({
          'password': pass,
          'email': email,
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          authMessages = e.code;
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          authMessages = e.code;
          print('Wrong password provided for that user.');
        }
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
          height: (!isLogin) ? 430 : 300,
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
              child: Column(
                children: [
                  if (!isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _image!=null?FileImage(_image!):null,
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
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
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
                  SizedBox(
                    height: 15,
                  ),
                  if (!isLogin)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
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
                    SizedBox(
                      height: 15,
                    ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        pass = val;
                      });
                    },
                    validator: (vVali) {
                      if (vVali!.isEmpty)
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
                  if (isLogin)
                    SizedBox(
                      height: 15,
                    ),
                  if (isLogin)
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .75,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                auth(context);
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                              });
                            },
                            child: Text('Sign In'))),
                  if (!isLogin)
                    SizedBox(
                      height: 10,
                    ),
                  if (!isLogin)
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .75,
                        child: ElevatedButton(
                            onPressed: () {

                              setState(() {
                                auth(context);
                                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('wait!!!!'),backgroundColor: Colors.red,));
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));

                              });

                            },
                            child: Text('Sign Up'))),
                  SizedBox(
                    height: 25,
                  ),
                  if (!isLogin)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text('Already have an account?'),
                    ),
                  if (isLogin)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text('create an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
