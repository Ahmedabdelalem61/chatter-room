// ignore_for_file: use_key_in_widget_constructors

import 'package:chatterbeings/widgets/messages_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
late final String url;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat').orderBy('time',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
            reverse: true,
            physics: const BouncingScrollPhysics(),//Text('${docs[index]['text']}')
            itemBuilder: (context, index) =>MessagesContainer(
            isme:docs[index]['uid']==FirebaseAuth.instance.currentUser?.uid,
              messages:docs[index]['text'] ,
              username: docs[index]['username'],
              ImageURL: docs[index]['imageUrl'],
            ) ,
            separatorBuilder: (context, index) =>SizedBox(width: 1,),
            itemCount: docs.length);
      },
    );
  }
}
