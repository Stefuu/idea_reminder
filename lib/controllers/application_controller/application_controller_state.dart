abstract class ApplicationControllerState {}

class ApplicationControllerStateInitial extends ApplicationControllerState {}

class ApplicationControllerStateLoading extends ApplicationControllerState {}

class ApplicationControllerStateLoaded extends ApplicationControllerState {
  ApplicationControllerStateLoaded({required this.videoPathList});

  List<String> videoPathList;
}
