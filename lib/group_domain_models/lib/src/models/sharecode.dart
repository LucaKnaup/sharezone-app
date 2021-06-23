import 'package:sharezone_common/api_errors.dart';

class Sharecode {
  final String value;

  Sharecode(this.value) : assert(isValid(value)) {
    if (!isValid(value)) {
      throw IncorrectSharecode();
    }
  }

  /// Checks if [sharecode] has the attributes of a sharecode:
  /// only small and big letters from alphabet and a length of 6.
  static bool isValid(String sharecode) {
    if (sharecode == null) return false;
    final sharecodeRegEx = RegExp(r"^[a-zA-Z0-9]{6}$");
    return sharecodeRegEx.hasMatch(sharecode);
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Sharecode && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
