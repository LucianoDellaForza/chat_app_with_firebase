import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat history'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logoutIdentifier', //identifier
              )
            ],
            onChanged: (itemIdentifier) {
              //used to see what action is pressed in DropdownButton
              if (itemIdentifier == 'logoutIdentifier') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            //Expanded needed becase Messages() has ListView and it wouldnt work well inside of Column
            child: Messages(),
          ),
          NewMesssage(),
        ],
      )),
    );
  }
}
