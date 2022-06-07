import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'video_recording_events.dart';
import 'video_recording_state.dart';

class VideoRecordingBloc
    extends Bloc<VideoRecordingEvents, VideoRecordingState> {
  VideoRecordingBloc() : super(VideoRecordingStateInitial()) {
    on<VideoRecordingEventsLoad>(_loadCamera);
  }

  FutureOr<void> _loadCamera(
    VideoRecordingEventsLoad event,
    Emitter<VideoRecordingState> emit,
  ) {
    emit(VideoRecordingStateLoaded());
  }
}
