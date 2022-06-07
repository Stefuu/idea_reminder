abstract class IdeaReminderState {}

class IdeaReminderStateInitial extends IdeaReminderState {}

class IdeaReminderStateLoading extends IdeaReminderState {}

class IdeaReminderStateLoaded extends IdeaReminderState {
  IdeaReminderStateLoaded({required this.videos});

  List<String> videos;
}