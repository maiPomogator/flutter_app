class NoteType {
  final String name;

  static const NoteType DAY = NoteType("Бакалавриат");
  static const NoteType LESSON = NoteType("Магистратура");

  const NoteType(this.name);

  @override
  String toString() {
    return 'NoteType{name: $name}';
  }

}

