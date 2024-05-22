import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket.IO Flutter Demo',
      home: SocketIOClient(),
    );
  }
}

class SocketIOClient extends StatefulWidget {
  @override
  _SocketIOClientState createState() => _SocketIOClientState();
}

class _SocketIOClientState extends State<SocketIOClient> {
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://192.168.26.178:8086', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      /*'query': {
        'username': "mohamed",
        'room': "1",
      },*/
    });

    socket!.onConnect((_) {
      print('Connected');
    });
    socket!.onConnectError((error) {
      print('Error connecting to server: $error');
    });

    socket!.on('response', (data) {
      print('Received response from server: $data');
    });

    socket!.connect();
  }

  void sendMessageToServer() {
    if (socket != null && socket!.connected) {
      socket!.emit('hello', 'Hello from Flutter');
    } else {
      print('Socket is not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Client'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendMessageToServer,
          child: Text('Send Message to Server'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
    }
    super.dispose();
  }
}
