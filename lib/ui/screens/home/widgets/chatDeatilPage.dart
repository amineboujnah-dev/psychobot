import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psychobot/core/models/chatMessageModel.dart';
import 'package:http/http.dart' as http;

class ChatDetailPage extends StatefulWidget {
  String PersonName;
  String imageUrl;

  ChatDetailPage({required this.PersonName, required this.imageUrl});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello!", messageType: "sender"),
    ChatMessage(messageContent: "Hiya", messageType: "receiver"),
    ChatMessage(messageContent: "How are you doing ?", messageType: "sender"),
    ChatMessage(
        messageContent: "I'm doing alright, you ?'", messageType: "receiver"),
    ChatMessage(messageContent: "Fine thanks", messageType: "sender"),
    ChatMessage(messageContent: "That's good", messageType: "receiver"),
    ChatMessage(
        messageContent: "Do you know any joke ?", messageType: "sender"),
    ChatMessage(
        messageContent: "I don't know any jokes", messageType: "receiver"),
    ChatMessage(messageContent: "How old are you ?", messageType: "sender"),
    ChatMessage(messageContent: "I'm 18'", messageType: "receiver"),
    ChatMessage(messageContent: "Good bye!", messageType: "sender"),
    ChatMessage(messageContent: "bye bye", messageType: "receiver"),
  ];
  String? name = "";
  String final_response =
      ""; //will be displayed on the screen once we get the data from the server
  int senderType = 0;
  List myList = [];
  String message = "";
  final _formkey = GlobalKey<FormState>();
  Future<void> _savingData() async {
    final validation = _formkey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.PersonName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == 'receiver'
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == 'receiver'
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          /*Text(
            "${final_response}${myList.length}",
            style: TextStyle(fontSize: 24),
          ),*/
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        onSaved: (value) {
                          name = value;
                          _formkey.currentState!.reset();
                          //getting data from the user form and assigning it to name
                        },
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      //validating the form and saving it
                      _savingData();

                      //url to send the post request to
                      final url = 'http://192.168.1.19:80/name';

                      //sending a post request to the url
                      final response = await http.post(Uri.parse(url),
                          body: json.encode({'name': name}));
                      final response2 = await http.get(Uri.parse(url));

                      //converting the fetched data from json to key value pair that can be displayed on the screen
                      final decoded =
                          json.decode(response2.body) as Map<String, dynamic>;
                      setState(() {
                        final_response = decoded['name'];
                        myList = decoded['myList'];
                        senderType = decoded['type'];
                        message = decoded['message'];
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                  /*FlatButton(
                    onPressed: () async {
                      //url to send the get request to
                      final url = 'http://192.168.1.19:80/name';

                      //getting data from the python server script and assigning it to response
                      final response = await http.get(Uri.parse(url));

                      //converting the fetched data from json to key value pair that can be displayed on the screen
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;

                      //changing the UI be reassigning the fetched data to final response
                      setState(() {
                        final_response = decoded['name'];
                        myList = decoded['myList'];
                      });
                    },
                    child: Text('GET'),
                    color: Colors.lightBlue,
                  ),*/

                  //displays the data on the screen
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
