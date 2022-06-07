import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'idea_reminder_events.dart';
import 'idea_reminder_state.dart';

class IdeaReminderBloc extends Bloc<IdeaReminderEvents, IdeaReminderState> {
  IdeaReminderBloc() : super(IdeaReminderStateInitial()) {
    on<IdeaReminderEventsLoad>(_loadVideos);
  }

  FutureOr<void> _loadVideos(
    IdeaReminderEventsLoad event,
    Emitter<IdeaReminderState> emit,
  ) {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
      (SharedPreferences instance) {
        final stringified = instance.getString('videoPathsList') ?? '[]';
        final List<String> parsedJson = List.from(jsonDecode(stringified));
        emit(IdeaReminderStateLoaded(
          videoPathList: parsedJson,
        ));
      },
    );
  }
}
