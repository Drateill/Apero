import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  final FirebaseUser user;

  const Chat({Key key, this.user}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

//Get user name
  final String _collection = 'user';
  final Firestore _fireStore = Firestore.instance;

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  getData() async {
    String uid = await inputData();
    return await _fireStore
        .collection(_collection)
        .where('id', isEqualTo: uid)
        .getDocuments();
  }

//====================================================================================================================================
  callBack() async {
    String username;
    await getData().then((val) {
      username = val.documents[0].data["name"];
    });
    if (messageController.text.length > 0) {
      await _firestore.collection('messages').add(
        {
          'text': messageController.text,
          'from': username,
          'date': DateTime.now().toIso8601String().toString(),
        },
      );
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 300),
      );
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40,
            child: Image.asset("assets/beer.png"),
          ),
        ),
        title: Text('Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              print(callBack);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
        
        child: Container(
                    decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    List<Widget> messages = docs
                        .map((doc) => Message(
                              from: doc.data['from'],
                              text: doc.data['text'],
                              // me: uname == doc.data['name']))
                              me: true,
                            ))
                        .toList();
                    return ListView(
                      controller: scrollController,
                      children: <Widget>[
                        ...messages,
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) => callBack(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Enter your message ...',
                          border: const OutlineInputBorder(),
                        ),
                        controller: messageController,
                      ),
                    ),
                    SendButton(
                      text: 'Send',
                      callBack: callBack,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final callBack;

  const SendButton({Key key, this.text, this.callBack});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: callBack,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          dense : true,
          title: Text('$from dit : $text', style: TextStyle(fontSize: 20)),
        ),
      );
    // return Container(
    //   child: Column(
    //     crossAxisAlignment:
    //         me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Text(from),
    //       Material(
    //         color: me ? Colors.orange[400] : Colors.red,
    //         borderRadius: BorderRadius.circular(10),
    //         elevation: 6,
    //         child: Container(
    //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //           child: Text(text, style: TextStyle(fontSize: 16)),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
