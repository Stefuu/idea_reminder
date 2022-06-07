import 'package:flutter/material.dart';
import './router/router.dart' as go_router;

void main() {
  runApp(IdeaReminder());
}

class IdeaReminder extends StatelessWidget {
  IdeaReminder({Key? key}) : super(key: key);

  final router = go_router.Router().router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idea reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Idea reminder'),
          ),
        ),
        body: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
        ),
      ),
    );
  }
}
