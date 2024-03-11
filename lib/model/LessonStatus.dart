enum LessonStatus {
  CREATED,
  SAVED,
  CANCELLED
}
LessonStatus lessonStatusFromString(String statusString) {
  switch (statusString) {
    case 'LessonStatus.CREATED':
      return LessonStatus.CREATED;
    case 'LessonStatus.SAVED':
      return LessonStatus.SAVED;
    case 'LessonStatus.CANCELLED':
      return LessonStatus.CANCELLED;
    default:
      throw ArgumentError('Invalid LessonStatus string: $statusString');
  }
}