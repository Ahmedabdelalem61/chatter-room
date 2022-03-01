import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Sender extends StatefulWidget {
  @override
  _SenderState createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  TextEditingController messagesController = TextEditingController();

  void submitMessage()async{
    FocusScope.of(context).unfocus();
    //make firebase send method here after make new field in firebase
    final uide = await FirebaseAuth.instance.currentUser?.uid;
    final userdata = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();

    FirebaseFirestore.instance
        .collection('chat').add({
      'text': messagesController.text,
      'time':Timestamp.now(),
      'username':userdata['username'],
      'uid':uide,
      'imageUrl' : userdata['imageUrl']
    });
    messagesController.clear();
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5,),
        Expanded(child:  TextFormField(
          onChanged: (val){
            setState(() {
            });
          },
          controller: messagesController,
          decoration:  InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelStyle: const TextStyle(color: Colors.pinkAccent),
            labelText: 'type new message'
          ),
        )),
        IconButton(onPressed: (){
          setState(() {
            submitMessage();
          });
        }, icon: Icon(Icons.send_rounded),color: messagesController.text.trim()
            .isEmpty?Colors.grey:Colors.pink)
      ],
    );
  }
}
