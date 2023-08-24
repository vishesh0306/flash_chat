import 'package:flutter/material.dart';
import 'package:flash/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if(user!=null){
          loggedInUser = user;
          print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _fireStore.collection("messages").get();
  //   for(var message in messages.docs){
  //     print(message.data());
  //   };
  // }

  void getStreams() async {
    await for(var snapshot in _fireStore.collection("messages").snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getStreams();
                // _auth.signOut();
                // Navigator.pop(context);
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

            messageStream(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender' : loggedInUser.email
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


class messageStream extends StatelessWidget {
  messageStream({Key? key}) : super(key: key);

  @override
  late bool isMe;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("messages").snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),);
          }
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for(var message in messages){
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = loggedInUser.email;
            if(currentUser == messageSender){
                  isMe = true;
            }
            else{
              isMe = false;
            }

            final messageBubble = MessageBubble(messageText, messageSender, isMe);
            messageBubbles..add(messageBubble);
            print(messageText);

          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageBubbles,
            ),
          );

        }
    );
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble(this.text,this.sender,this.isMe);
  late final String text;
  late final String sender;
  late bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text((sender),style: TextStyle(
            fontSize: 10,
              color: Colors.blueGrey
          ),),
          Material(
          elevation: 5,
          borderRadius: BorderRadius.only(
              topLeft: isMe? Radius.circular(30) : Radius.zero,
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            topRight: isMe? Radius.zero : Radius.circular(30)

          ),

          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Text('$text',
              style: TextStyle(fontSize: 15,
              color: isMe? Colors.white : Colors.blueGrey),
            ),
          ),
        ),
      ]),
    );
  }
}

