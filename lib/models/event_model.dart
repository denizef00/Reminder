class EventModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    bool? isCompleted,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
