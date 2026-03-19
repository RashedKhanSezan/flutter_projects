class Todo {
  String id;
  String title;
  bool isChecked;

  Todo({
    required this.id,
    required this.title,
    this.isChecked = false,
  });

  void boxChecked() {
    isChecked = !isChecked;
  }
}
