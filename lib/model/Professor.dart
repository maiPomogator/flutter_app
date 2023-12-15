import 'dart:ffi';
import 'package:uuid/uuid.dart';

class Professor{
  final Long id;
  final String lastName;
  final String firstName;
  final String middleName;
  final Uuid siteId;

  const Professor(this.id, this.lastName, this.firstName, this.middleName, this.siteId);
}