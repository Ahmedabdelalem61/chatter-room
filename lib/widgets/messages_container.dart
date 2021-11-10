import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagesContainer extends StatelessWidget {
  final bool isme;
  final String ImageURL;

  final String username;
  final String messages;

  const MessagesContainer({required this.ImageURL,required this.isme, required this.username,required this.messages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                  color: !isme ? Colors.grey[300] : Colors.pink,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: isme ? Radius.circular(15) : Radius.circular(0),
                    bottomRight: !isme ? Radius.circular(15) : Radius.circular(0),
                  )),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              width: 140,
              child: Column(
                  crossAxisAlignment:
                  isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [Text(username,style: TextStyle(color: isme?Colors.black:Colors.white,fontWeight: FontWeight.bold),),
                    Text(messages,style: TextStyle(color: isme?Colors.black54:Colors.white),),
                  ]),
            ),
            Positioned(
                top: 0,
                right: isme?120:null,
                left: !isme?120:null,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(ImageURL),
                )),
          ],
        ),
      ],
    );
  }
}
