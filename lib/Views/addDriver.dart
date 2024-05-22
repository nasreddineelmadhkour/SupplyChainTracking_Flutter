import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

/*
class StompClientExample extends StatefulWidget {
  @override
  _StompClientExampleState createState() => _StompClientExampleState();
}

class _StompClientExampleState extends State<StompClientExample> {
  final channel = IOWebSocketChannel.connect('ws://172.17.20.69:3000/chat-socket');
  late StompClient stompClient;

  @override
  void initState() {
    super.initState();

    stompClient = StompClient(
      config: StompConfig(
          url: 'wss://172.17.20.69:3000/ws/app/chat/1',
        onConnect: onConnect,
        onWebSocketError: onWebSocketError,
      ),
    );
    stompClient.activate();
  }

  void onConnect(StompFrame connectFrame) {
    print('Connected to STOMP server');
    stompClient.subscribe(destination: '/topic/1', callback: (StompFrame frame) {
        print('Received message: ${frame.body}');
      },
    );
  }

  void onWebSocketError(dynamic error) {
    print('WebSocket error: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STOMP Client Example'),
      ),
      body: Center(
        child: Text('Listening for messages...'),
      ),
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    channel.sink.close();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: StompClientExample(),
  ));
}
*/