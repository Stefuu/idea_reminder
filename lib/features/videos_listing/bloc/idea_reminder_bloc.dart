import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(IdeaReminderStateLoaded(
      videos: event.videos,
    ));
  }
}
