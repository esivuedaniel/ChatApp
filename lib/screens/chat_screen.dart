import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chating_app/constants.dart';
import 'package:firebase_chating_app/screens/FirebasDb.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore=FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
   String messageText;
   final messageTextController=TextEditingController();


  @override
  void initState() {
    getCurrentUser();
  }

  void getCurrentUser()async{
    //retreive user email from fb
    try{
    final user=await _auth.currentUser;
    if(user !=null){
      loggedInUser=user;
      print(loggedInUser.email);
      print(loggedInUser.phoneNumber);
      print(loggedInUser.uid);
    }}catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut(); //firebase signout
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //the reason why we use streambuilder is because it returns data to user from fb immediately it is sent
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // FlatButton(
                  //   onPressed: () {
                  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FirebasDb()));
                  //   },
                  //   child: Text(
                  //     'DataB',
                  //     style: kSendButtonTextStyle,
                  //   ),
                  // ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(), //this received the stored messages in fb
        builder: (context, snapshot){
          if(snapshot.hasData){
            final messages=snapshot.data.docs.reversed;
            List<MessageBubble> messageBubbles=[];

            for(var message in messages){
              final messageText=message.data()['text'];  //the "text" and "sender" should be the same as what we have in our cloudfirestore
              final messageSender=message.data()['sender'];

              final messageBubble=MessageBubble(text: messageText, sender: messageSender, isMe: messageSender==loggedInUser.email,);
              messageBubbles.add(messageBubble);
            }

            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messageBubbles,
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
            color: isMe? Colors.lightBlueAccent : Colors.white,
            elevation: 5,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30))  :
            BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              topRight: Radius.circular(30)
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(text ,
              style: TextStyle(
                fontSize: 15,
                color:isMe? Colors.white : Colors.black54
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
