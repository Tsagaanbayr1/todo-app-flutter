class TaskModel {
  final int id;
  final String title;
  bool isChecked;

  TaskModel({required this.id, required this.title, this.isChecked = false});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isChecked: json['isChecked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isChecked': isChecked,
    };
  }
}
