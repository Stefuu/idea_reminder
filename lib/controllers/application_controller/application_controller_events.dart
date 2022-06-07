class ApplicationControllerEvents {}

class ApplicationControllerEventsLoad extends ApplicationControllerEvents {}

class ApplicationControllerEventsAddVideo extends ApplicationControllerEvents {
  ApplicationControllerEventsAddVideo(this.videoPath);

  final String videoPath;
}

class ApplicationControllerEventsRemoveVideo
    extends ApplicationControllerEvents {
  ApplicationControllerEventsRemoveVideo(this.videoIndex);

  final int videoIndex;
}
