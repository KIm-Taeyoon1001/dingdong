class SchoolInfo {
  const SchoolInfo({required this.name, required this.officeCode, required this.schoolCode, required this.schoolKind});
  final String name;
  final String officeCode;
  final String schoolCode;
  final String schoolKind;
  factory SchoolInfo.fromNeis(Map<String, dynamic> json) => SchoolInfo(
    name: '${json['SCHUL_NM'] ?? ''}',
    officeCode: '${json['ATPT_OFCDC_SC_CODE'] ?? ''}',
    schoolCode: '${json['SD_SCHUL_CODE'] ?? ''}',
    schoolKind: '${json['SCHUL_KND_SC_NM'] ?? ''}',
  );
}
class Lesson {
  const Lesson({required this.period, required this.subject});
  final int period;
  final String subject;
}
class MealInfo {
  const MealInfo({required this.name, required this.dishes, this.calories = ''});
  final String name;
  final List<String> dishes;
  final String calories;
}
class SchoolDay {
  const SchoolDay({required this.date, required this.lessons, this.meal});
  final DateTime date;
  final List<Lesson> lessons;
  final MealInfo? meal;
}
