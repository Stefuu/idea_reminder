import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './router/router.dart' as go_router;
import 'controllers/application_controller/application_controller_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationControllerBloc>(
          create: (BuildContext context) => ApplicationControllerBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          );
        },
      ),
    );
  }
}
