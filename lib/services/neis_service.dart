import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/school_day.dart';

class NeisService {
  NeisService({http.Client? client}) : _client = client ?? http.Client();
  static const _base = 'https://open.neis.go.kr/hub';
  static const apiKey = String.fromEnvironment('NEIS_API_KEY');
  final http.Client _client;

  Future<List<SchoolInfo>> searchSchools(String name) async {
    _requireKey();
    final data = await _get('schoolInfo', {'SCHUL_NM': name, 'pIndex': '1', 'pSize': '30'});
    return _rows(data, 'schoolInfo').map(SchoolInfo.fromNeis).toList();
  }

  Future<SchoolDay> loadDay({required SchoolInfo school, required String schoolLevel, required String grade, required String className, required DateTime date}) async {
    _requireKey();
    final ymd = '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    final mealJson = await _get('mealServiceDietInfo', {
      'ATPT_OFCDC_SC_CODE': school.officeCode, 'SD_SCHUL_CODE': school.schoolCode,
      'MLSV_FROM_YMD': ymd, 'MLSV_TO_YMD': ymd,
    });
    final mealRows = _rows(mealJson, 'mealServiceDietInfo');
    final row = mealRows.isEmpty ? null : mealRows.first;
    final meal = row == null ? null : MealInfo(
      name: '${row['MMEAL_SC_NM'] ?? '급식'}',
      dishes: '${row['DDISH_NM'] ?? ''}'.split(RegExp(r'<br\s*/?>'))
        .map((s) => s.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim()).where((s) => s.isNotEmpty).toList(),
      calories: '${row['CAL_INFO'] ?? ''}',
    );
    final endpoint = switch (schoolLevel) {
      '초등학교' => 'elsTimetable', '중학교' => 'misTimetable', _ => 'hisTimetable',
    };
    final timetable = await _get(endpoint, {
      'ATPT_OFCDC_SC_CODE': school.officeCode, 'SD_SCHUL_CODE': school.schoolCode,
      'ALL_TI_YMD': ymd, 'GRADE': grade, 'CLASS_NM': className,
    });
    final lessons = _rows(timetable, endpoint).map((r) => Lesson(
      period: int.tryParse('${r['PERIO'] ?? ''}') ?? 0,
      subject: '${r['ITRT_CNTNT'] ?? r['SUBJECT'] ?? ''}'.trim(),
    )).where((l) => l.period > 0 && l.subject.isNotEmpty).toList()
      ..sort((a, b) => a.period.compareTo(b.period));
    return SchoolDay(date: date, lessons: lessons, meal: meal);
  }

  Future<Map<String, dynamic>> _get(String endpoint, Map<String, String> query) async {
    final uri = Uri.parse('$_base/$endpoint').replace(queryParameters: {'KEY': apiKey, 'Type': 'json', ...query});
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) throw Exception('NEIS 요청 실패 (${response.statusCode})');
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body is! Map<String, dynamic>) throw const FormatException('NEIS 응답 형식 오류');
    if (body.containsKey('RESULT')) {
      final result = body['RESULT'];
      throw Exception('NEIS 응답: ${result is Map ? result['MESSAGE'] : result}');
    }
    return body;
  }

  List<Map<String, dynamic>> _rows(Map<String, dynamic> json, String key) {
    final sections = json[key];
    if (sections is! List) return const [];
    for (final section in sections) {
      if (section is Map && section['row'] is List) {
        return (section['row'] as List).whereType<Map>()
          .map((r) => Map<String, dynamic>.from(r)).toList();
      }
    }
    return const [];
  }

  void _requireKey() {
    if (apiKey.isEmpty) throw StateError('빌드 시 --dart-define=NEIS_API_KEY=... 를 전달하세요.');
  }
  void dispose() => _client.close();
}
