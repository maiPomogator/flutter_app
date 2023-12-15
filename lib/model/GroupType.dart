class GroupType {
  final String name;

  static const GroupType BACHELOR = GroupType("Бакалавриат");
  static const GroupType MAGISTRACY = GroupType("Магистратура");
  static const GroupType POSTGRADUATE = GroupType("Аспирантура");
  static const GroupType SPECIALIST = GroupType("Специалитет");
  static const GroupType BASIC_HIGHER_EDUCATION =
  GroupType("Базовое высшее образование");
  static const GroupType SPECIALIZED_HIGHER_EDUCATION =
  GroupType("Специализированное высшее образование");

  const GroupType(this.name);

  @override
  String toString() {
    return 'GroupType{name: $name}';
  }

  String getFullName() {
    return name;
  }

  static GroupType fromString(String typeName) {
    switch (typeName) {
      case "Бакалавриат":
        return BACHELOR;
      case "Магистратура":
        return MAGISTRACY;
      case "Аспирантура":
        return POSTGRADUATE;
      case "Специалитет":
        return SPECIALIST;
      case "Базовое высшее образование":
        return BASIC_HIGHER_EDUCATION;
      case "Специализированное высшее образование":
        return SPECIALIZED_HIGHER_EDUCATION;
      default:
        throw ArgumentError("Invalid GroupType: $typeName");
    }
  }
}

