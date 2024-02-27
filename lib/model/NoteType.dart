class NoteType {
  final String name;

  static const NoteType DAY = NoteType("день");
  static const NoteType LESSON = NoteType("занятие");

  const NoteType(this.name);

  @override
  String toString() {
    return 'NoteType{name: $name}';
  }

}

