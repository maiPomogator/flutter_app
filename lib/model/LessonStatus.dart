enum LessonStatus {
  CREATED,
  SAVED,
  CANCELLED
}
LessonStatus lessonStatusFromString(String statusString) {
  switch (statusString) {
    case 'CREATED':
      return LessonStatus.CREATED;
    case 'SAVED':
      return LessonStatus.SAVED;
    case 'CANCELLED':
      return LessonStatus.CANCELLED;
    default:
      throw ArgumentError('Invalid LessonStatus string: $statusString');
  }
}