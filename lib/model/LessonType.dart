class LessonType {
  final String name;
  final String shortName;

  const LessonType(this.name, this.shortName);

  static const LessonType LECTURE = LessonType("Лекция", "ЛК");
  static const LessonType PRACTICE = LessonType("Практическое занятие", "ПЗ");
  static const LessonType LABORATORY = LessonType("Лабораторная работа", "ЛР");
  static const LessonType CONSULTATION = LessonType("Консультация", "Конс.");
  static const LessonType CREDIT = LessonType("Зачёт", "Зач.");
  static const LessonType EXAM = LessonType("Экзамен", "Экз.");

  @override
  String toString() {
    return 'LessonType{name: $name, shortName: $shortName}';
  }

  String getShortName() {
    return shortName;
  }

  String getFullName() {
    return name;
  }

  static LessonType fromString(String typeName) {
    switch (typeName) {
      case "Лекция":
        return LECTURE;
      case "Практическое занятие":
        return PRACTICE;
      case "Лабораторная работа":
        return LABORATORY;
      case "Консультация":
        return CONSULTATION;
      case "Зачёт":
        return CREDIT;
      case "Экзамен":
        return EXAM;
      case "LECTURE":
        return LECTURE;
      case "PRACTICE":
        return PRACTICE;
      case 'LABORATORY':
        return LABORATORY;
      case "CONSULTATION":
        return CONSULTATION;
      case "CREDIT":
        return CREDIT;
      case "EXAM":
        return EXAM;
      default:
        throw ArgumentError("Invalid LessonType: $typeName");
    }
  }
}
