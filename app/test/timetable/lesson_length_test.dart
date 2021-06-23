import 'package:time/time.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:test/test.dart';

void main() {
  test('calculate lesson length', () {
    expectLessonLength(Time.parse("15:30"), Time.parse("16:30"), 60);
    expectLessonLength(Time.parse("15:30"), Time.parse("17:30"), 120);
    expectLessonLength(Time.parse("15:30"), Time.parse("15:30"), 0);
    expectLessonLength(Time.parse("15:30"), Time.parse("14:30"), -60);
    expectLessonLength(Time.parse("00:00"), Time.parse("23:00"), 23 * 60);
    expectLessonLength(Time.parse("23:00"), Time.parse("24:00"), 60);
    expectLessonLength(Time.parse("00:00"), Time.parse("24:00"), 24 * 60);
    expectLessonLength(Time.parse("16:15"), Time.parse("14:40"), -95);
  });
}

void expectLessonLength(Time start, Time end, int minutes) {
  final length = calculateLessonLength(start, end);
  expect(length.minutes, minutes);
}
