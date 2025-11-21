class Task {
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isCompleted;
  String category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.isCompleted = false,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      category: json['category'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
