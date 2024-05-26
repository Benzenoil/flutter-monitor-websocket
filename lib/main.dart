import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WebSocketScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class WebSocketScreen extends StatefulWidget {
  const WebSocketScreen({Key? key}) : super(key: key);

  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8082/ws'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Health Monitor'),
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          Color bgColor = Colors.grey; // Default background color
          String message = 'Waiting for data...'; // Default text message

          if (snapshot.hasData) {
            final data = snapshot.data.toString();
            if (data == 'healthy') {
              bgColor = Colors.green;
              message = 'Service is Healthy';
            } else if (data == 'offline') {
              bgColor = Colors.red;
              message = 'Service is Offline';
            }
          }

          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: bgColor,
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
