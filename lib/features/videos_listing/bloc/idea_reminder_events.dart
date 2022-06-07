class IdeaReminderEvents {}

class IdeaReminderEventsLoad extends IdeaReminderEvents {
  IdeaReminderEventsLoad({required this.videos});

  List<String> videos;
}
