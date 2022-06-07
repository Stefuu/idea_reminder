import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idea_reminder/controllers/application_controller/application_controller_events.dart';
import 'package:idea_reminder/controllers/application_controller/application_controller_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationControllerBloc
    extends Bloc<ApplicationControllerEvents, ApplicationControllerState> {
  ApplicationControllerBloc() : super(ApplicationControllerStateInitial()) {
    on<ApplicationControllerEventsAddVideo>(_addVideo);
    on<ApplicationControllerEventsLoad>(_loadVideos);
    on<ApplicationControllerEventsRemoveVideo>(_removeVideo);
  }

  final List<String> _videoPathList = [];

  FutureOr<void> _loadVideos(
    ApplicationControllerEventsLoad event,
    Emitter<ApplicationControllerState> emit,
  ) {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
      (SharedPreferences instance) {
        final stringified = instance.getString('videoPathsList') ?? '[]';
        final List<String> parsedJson = List.from(jsonDecode(stringified));
        emit(ApplicationControllerStateLoaded(
          videoPathList: parsedJson,
        ));
      },
    );
  }

  FutureOr<void> _addVideo(
    ApplicationControllerEventsAddVideo event,
    Emitter<ApplicationControllerState> emit,
  ) {
    _videoPathList.add(event.videoPath);
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
      (SharedPreferences instance) {
        instance.setString('videoPathsList', jsonEncode(_videoPathList));
        emit(ApplicationControllerStateLoaded(
          videoPathList: _videoPathList,
        ));
      },
    );
  }

  FutureOr<void> _removeVideo(
    ApplicationControllerEventsRemoveVideo event,
    Emitter<ApplicationControllerState> emit,
  ) {
    _videoPathList.removeAt(event.videoIndex);
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
      (SharedPreferences instance) {
        final listOnSharedPrefs =
            List.from(jsonDecode(instance.getString('videoPathsList') ?? '[]'));
        listOnSharedPrefs.removeAt(event.videoIndex);
        instance.setString('videoPathsList', jsonEncode(_videoPathList));
        emit(ApplicationControllerStateLoaded(
          videoPathList: _videoPathList,
        ));
      },
    );
  }
}
