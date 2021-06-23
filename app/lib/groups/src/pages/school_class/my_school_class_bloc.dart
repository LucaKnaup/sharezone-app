import 'package:app_functions/app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:meta/meta.dart';
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_common/helper_functions.dart';

enum SchoolClassDeleteType {
  withCourses,
  withoutCourses,
}

SchoolClassDeleteType schoolClassDeleteTypeFromString(String data) =>
    enumFromString(SchoolClassDeleteType.values, data);
String schoolClassTypeToString(SchoolClassDeleteType data) =>
    enumToString(data);

class MySchoolClassBloc extends BlocBase {
  final SharezoneGateway gateway;
  final SchoolClass schoolClass;
  String schoolClassId;

  MySchoolClassBloc({@required this.gateway, this.schoolClass}) {
    if (schoolClass != null) schoolClassId = schoolClassId;
  }

  Future<AppFunctionsResult<bool>> createSchoolClass(String name) {
    final schoolClassData = SchoolClassData.create().copyWith(
      id: gateway.references.schoolClasses.doc().id,
      name: name,
    );
    schoolClassId = schoolClassData.id;
    return gateway.schoolClassGateway.createSchoolClass(schoolClassData);
  }

  Stream<List<SchoolClass>> streamSchoolClasses() {
    return gateway.schoolClassGateway.stream();
  }

  Stream<WritePermission> writePermissionStream() {
    return streamSchoolClass()
        .map((schoolClass) => schoolClass.settings.writePermission)
        .asBroadcastStream();
  }

  Stream<SchoolClass> streamSchoolClass() {
    return gateway.schoolClassGateway.streamSingleSchoolClass(schoolClass.id);
  }

  Stream<List<MemberData>> streamMembers(String schoolClassID) {
    return gateway.schoolClassGateway.memberAccessor
        .streamAllMembers(schoolClassID);
  }

  Stream<MemberData> streamMember(String schoolClassID, String memberID) {
    return gateway.schoolClassGateway.memberAccessor
        .streamSingleMember(schoolClassID, memberID);
  }

  Future<AppFunctionsResult<bool>> updateMemberRole(
      String schoolClassID, UserId memberID, MemberRole newRole) {
    return gateway.schoolClassGateway
        .updateMemberRole(schoolClassID, memberID.toString(), newRole);
  }

  Future<AppFunctionsResult<bool>> generateNewMeetingID(String schoolClassId) {
    return gateway.schoolClassGateway.generateNewMeetingID(schoolClassId);
  }

  bool moreThanOneAdmin(List<MemberData> membersDataList) {
    if (membersDataList
            .where((it) => requestPermission(
                role: it.role, permissiontype: PermissionAccessType.admin))
            .length >
        1) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<Course>> streamCourses(String schoolClassID) {
    return gateway.schoolClassGateway.streamCourses(schoolClassID);
  }

  Future<AppFunctionsResult<bool>> leaveSchoolClass() async {
    return gateway.schoolClassGateway.leaveSchoolClass(schoolClass.id);
  }

  Future<AppFunctionsResult<bool>> deleteSchoolClass(
      SchoolClassDeleteType schoolClassDeleteType) async {
    return gateway.schoolClassGateway
        .deleteSchoolClass(schoolClass.id, schoolClassDeleteType);
  }

  Future<AppFunctionsResult<bool>> kickMember(String kickedMemberID) async {
    return gateway.schoolClassGateway
        .kickMember(schoolClass.id, kickedMemberID);
  }

  Future<AppFunctionsResult<bool>> setIsPublic(bool isPublic) {
    return gateway.schoolClassGateway.editSchoolClassSettings(
        schoolClass.id, schoolClass.settings.copyWith(isPublic: isPublic));
  }

  Future<AppFunctionsResult<bool>> setIsGroupMeetingEnabled(
      bool isMeetingEnabled) {
    return gateway.schoolClassGateway.editSchoolClassSettings(schoolClass.id,
        schoolClass.settings.copyWith(isMeetingEnabled: isMeetingEnabled));
  }

  Future<bool> setWritePermission(WritePermission writePermission) {
    return gateway.schoolClassGateway
        .editSchoolClassSettings(schoolClass.id,
            schoolClass.settings.copyWith(writePermission: writePermission))
        .then((result) => result.hasData && result.data == true);
  }

  bool isAdmin() {
    return requestPermission(
        role: schoolClass.myRole, permissiontype: PermissionAccessType.admin);
  }

  Stream<bool> isAdminStream() {
    return streamSchoolClass().map((sc) => requestPermission(
        role: sc.myRole, permissiontype: PermissionAccessType.admin));
  }

  @override
  void dispose() {}
}
