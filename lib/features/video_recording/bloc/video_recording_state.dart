abstract class VideoRecordingState {}

class VideoRecordingStateInitial extends VideoRecordingState {}

class VideoRecordingStateLoading extends VideoRecordingState {}

class VideoRecordingStateLoaded extends VideoRecordingState {
  VideoRecordingStateLoaded(this.videoPathList);

  final List<String> videoPathList;
}
