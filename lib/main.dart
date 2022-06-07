import 'package:flutter/material.dart';
import './router/router.dart' as go_router;

void main() {
  runApp(IdeaReminder());
}

class IdeaReminder extends StatefulWidget {
  IdeaReminder({Key? key}) : super(key: key);

  @override
  State<IdeaReminder> createState() => _IdeaReminderState();
}

class _IdeaReminderState extends State<IdeaReminder> {
  final router = go_router.Router().router;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hiking),
              label: 'Record',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tips_and_updates),
              label: 'Play',
              backgroundColor: Colors.blueGrey,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            switch (index) {
              case 0:
                router.go('/');
                break;
              case 1:
                router.go('/record');
                break;
              case 3:
                router.go('/play');
                break;
              default:
                router.go('/');
            }

            _onItemTapped(index);
          },
        ),
      ),
    );
  }
}
