class EventModel {
  final int id;
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
    int? id,
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: json["date"],
      time: json["time"],
      isCompleted: json["isCompleted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "time": time,
      "isCompleted": isCompleted,
    };
  }
}
