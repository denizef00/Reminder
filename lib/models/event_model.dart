class EventModel {
  final String title;
  final String date;
  final String time;

  EventModel({required this.title, required this.date, required this.time});

  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date, 'time': time};
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
