class VideoRecordingEvents {}

class VideoRecordingEventsAddVideo extends VideoRecordingEvents {
  VideoRecordingEventsAddVideo(this.videoPath);

  final String videoPath;
}
