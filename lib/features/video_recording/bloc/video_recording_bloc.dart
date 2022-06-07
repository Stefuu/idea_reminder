import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(VideoRecordingStateLoaded(_videoPathList));
  }
}
