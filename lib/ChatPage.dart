import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';

import 'package:supplychaintracking/Network/BaseURL.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StompClient _stompClient;  // Declare as late
  List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    _stompClient =
        StompClient(
      config: StompConfig(
        url: BaseURL.baseURL_WS,
        onConnect: _onConnect,
        onStompError: (error) {
          print('STOMP Error occurred: $error');
        },
        onWebSocketError: (error) {
          print('WebSocket Error occurred: $error');
        },
      ),
    );

    _stompClient.activate();
  }


  void _onConnect(StompFrame frame) {
    _stompClient.subscribe(
      destination: '/topic/1', // Update with your subscription topic
      callback: (frame) {
        Map<String, dynamic> result = json.decode(frame.body!);  // Add null check with '!'
        setState(() {
          messages.add(result['message']);
        });
      },
    );
  }

  void _sendMessage(String message) {
    if (_stompClient.connected) {
      if (message.isNotEmpty) {
        _stompClient.send(
          destination: '/app/chat/1', // Update with your destination
          body: json.encode({'message': message, 'user': 'User'}),
        );
        _controller.clear();
      }
    } else {
      print('WebSocket connection is not established.');
      // You can attempt to reconnect here or display an error message to the user.
    }
  }


  @override
  void dispose() {
    _stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
