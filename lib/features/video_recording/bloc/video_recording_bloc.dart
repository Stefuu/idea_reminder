import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'video_recording_events.dart';
import 'video_recording_state.dart';

class VideoRecordingBloc
    extends Bloc<VideoRecordingEvents, VideoRecordingState> {
  VideoRecordingBloc() : super(VideoRecordingStateInitial()) {
    on<VideoRecordingEventsAddVideo>(_addVideo);
  }

  final List<String> _videoPathList = [];

  FutureOr<void> _addVideo(
    VideoRecordingEventsAddVideo event,
    Emitter<VideoRecordingState> emit,
  ) {
    _videoPathList.add(event.videoPath);
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
      (SharedPreferences instance) {
        instance.setString('videoPathsList', jsonEncode(_videoPathList));
      },
    );
  }
}
