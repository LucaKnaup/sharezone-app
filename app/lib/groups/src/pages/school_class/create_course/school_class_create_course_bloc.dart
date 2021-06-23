import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:analytics/analytics.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/groups/src/pages/course/create/src/analytics/course_create_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/src/analytics/events/course_create_event.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/user_input.dart';
import 'package:sharezone/groups/src/pages/course/create/src/models/course_template.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone/util/string_utils.dart';
import 'package:sharezone_common/course_validators.dart';
import 'package:sharezone_common/validators.dart';

class SchoolClassCourseCreateBloc extends BlocBase with CourseValidators {
  final _analytics = CourseCreateAnalytics(Analytics(getBackend()));

  final _nameSubject = BehaviorSubject<String>();
  final _subjectSubject = BehaviorSubject<String>();
  final _abbreviationSubject = BehaviorSubject<String>();
  final String schoolClassID;
  final SharezoneGateway gateway;

  final Course initalCourse;

  SchoolClassCourseCreateBloc(
      {@required this.gateway,
      @required this.schoolClassID,
      this.initalCourse}) {
    if (initalCourse != null) _addInitalValuesToStream(initalCourse);
  }

  void _addInitalValuesToStream(Course course) {
    _nameSubject.sink.add(course.name);
    _subjectSubject.sink.add(course.subject);
    _abbreviationSubject.sink.add(course.abbreviation);
  }

  Stream<String> get subject =>
      _subjectSubject.stream.transform(validateSubject);

  // Change data
  Function(String) get changeName => _nameSubject.sink.add;
  Function(String) get changeSubject => _subjectSubject.sink.add;
  Function(String) get changeAbbreviation => _abbreviationSubject.sink.add;

  bool hasUserEditInput() {
    final name = _nameSubject.value;
    final subject = _subjectSubject.value;
    final abbreviation = _abbreviationSubject.value;

    if (initalCourse == null) {
      return isNotEmptyOrNull(name) ||
          isNotEmptyOrNull(subject) ||
          isNotEmptyOrNull(abbreviation);
    } else {
      return !(name == initalCourse.name ||
          subject == initalCourse.subject ||
          abbreviation == initalCourse.abbreviation);
    }
  }

  Future<bool> submit() async {
    final validator = NotEmptyOrNullValidator(_subjectSubject.value);
    if (!validator.isValid()) {
      _subjectSubject.addError(
          TextValidationException(CourseValidators.emptySubjectUserMessage));
      throw InvalidInputException();
    }

    final subject = _subjectSubject.value;
    final name = _ifNotGivenGenerateName(_nameSubject.value, subject);
    final abbreviation =
        _ifNotGivenGenerateAbbreviation(_abbreviationSubject.value, subject);

    final userInput = UserInput(name, subject, abbreviation);
    _analytics.logCourseCreateFromOwn(subject, schoolClassPage);

    final result = await gateway.schoolClassGateway.createCourse(
      schoolClassID,
      CourseData.create().copyWith(
        name: userInput.name,
        abbreviation: userInput.abbreviation,
        subject: userInput.subject,
      ),
    );
    return result.hasData && result.data == true;
  }

  Future<bool> submitWithCourseTemplate(CourseTemplate courseTemplate) async {
    _analytics.logCourseCreateFromTemplate(courseTemplate, schoolClassPage);

    // With the course template the course name is equel to the course subject
    final userInput = UserInput(courseTemplate.subject, courseTemplate.subject,
        courseTemplate.abbreviation);
    final result = await gateway.schoolClassGateway.createCourse(
      schoolClassID,
      CourseData.create().copyWith(
        name: userInput.name,
        abbreviation: userInput.abbreviation,
        subject: userInput.subject,
      ),
    );
    return result.hasData && result.data == true;
  }

  bool isCourseTemplateAlreadyAdded(CourseTemplate courseTemplate) {
    final courses = gateway.course.getCurrentCourses();
    final highest = StringUtils.getHighestSimilarity(
        courses.map((course) => course.subject.toLowerCase()).toList(),
        courseTemplate.subject.toLowerCase());
    return highest >= 0.7;
  }

  String _ifNotGivenGenerateName(String name, String subject) {
    if (NotEmptyOrNullValidator(name).isValid()) return name;
    return subject;
  }

  String _ifNotGivenGenerateAbbreviation(String abbreviation, String subject) {
    if (NotEmptyOrNullValidator(abbreviation).isValid()) return abbreviation;
    return subject.length >= 2
        ? subject.substring(0, 2).toUpperCase()
        : subject;
  }

  @override
  void dispose() {
    _nameSubject.close();
    _subjectSubject.close();
    _abbreviationSubject.close();
  }
}
