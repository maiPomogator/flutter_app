import 'package:uuid/uuid.dart';

class Professor {
  final int id;
  final String lastName;
  final String firstName;
  final String middleName;
  final Uuid siteId;
  final bool isMain;

  const Professor(this.id, this.lastName, this.firstName, this.middleName,
      this.siteId, this.isMain);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'middleName': middleName,
      'siteId': siteId,
      'isMain': isMain ? 1 : 0,
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      map['id'],
      map['lastName'],
      map['firstName'],
      map['middleName'],
      map['siteId'],
      map['isMain'] == 1,
    );
  }
}
