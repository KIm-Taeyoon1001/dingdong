import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/school_day.dart';
import '../services/neis_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = NeisService();
  final _schoolName = TextEditingController();
  final _grade = TextEditingController(text: '1');
  final _classNo = TextEditingController(text: '1');
  List<SchoolInfo> _results = [];
  SchoolInfo? _school;
  SchoolDay? _day;
  String _level = '고등학교';
  bool _busy = false;
  String? _error;

  Future<void> _search() async {
    setState(() { _busy = true; _error = null; });
    try { _results = await _api.searchSchools(_schoolName.text.trim()); }
    catch (e) { _error = e.toString(); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _sync() async {
    if (_school == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      _day = await _api.loadDay(school: _school!, schoolLevel: _level, grade: _grade.text.trim(), className: _classNo.text.trim(), date: DateTime.now());
    } catch (e) { _error = e.toString(); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  void dispose() { _schoolName.dispose(); _grade.dispose(); _classNo.dispose(); _api.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('M월 d일 EEEE', 'ko_KR').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('딩동', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: _busy ? null : _sync, icon: const Icon(Icons.refresh))]),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Text(date, style: Theme.of(context).textTheme.titleMedium),
        Text('오늘의 학교생활을 한눈에', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text('학교 설정', style: Theme.of(context).textTheme.titleLarge),
        TextField(controller: _schoolName, decoration: const InputDecoration(labelText: '학교명')),
        FilledButton.tonal(onPressed: _busy ? null : _search, child: const Text('학교 검색')),
        ..._results.map((s) => ListTile(title: Text(s.name), subtitle: Text('${s.schoolKind} · ${s.officeCode}'), onTap: () => setState(() { _school = s; _results = []; }))),
        DropdownButtonFormField<String>(value: _level, decoration: const InputDecoration(labelText: '학교급'), items: ['초등학교','중학교','고등학교'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => _level = v ?? _level)),
        Row(children: [
          Expanded(child: TextField(controller: _grade, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '학년'))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: _classNo, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '반'))),
        ]),
        const SizedBox(height: 8),
        FilledButton(onPressed: _busy || _school == null ? null : _sync, child: Text(_busy ? '불러오는 중…' : '시간표·급식 불러오기')),
        if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        const SizedBox(height: 20),
        Text('오늘의 시간표', style: Theme.of(context).textTheme.titleLarge),
        if (_day == null) const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('학교를 설정하고 데이터를 불러오세요.'))),
        if (_day != null && _day!.lessons.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('등록된 시간표가 없습니다.'))),
        if (_day != null) ..._day!.lessons.map((l) => Card(child: ListTile(leading: CircleAvatar(child: Text('${l.period}')), title: Text(l.subject), subtitle: Text('${l.period}교시')))),
        const SizedBox(height: 16),
        Text('오늘의 급식', style: Theme.of(context).textTheme.titleLarge),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: _day?.meal == null ? const Text('급식 정보가 없습니다.') : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_day!.meal!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ..._day!.meal!.dishes.map((d) => Text('· $d')),
          if (_day!.meal!.calories.isNotEmpty) Text(_day!.meal!.calories),
        ]))),
        const SizedBox(height: 12),
        const Text('NEIS에 등록된 데이터를 조회합니다. 학교가 변경 내용을 입력한 뒤 다시 동기화하면 반영됩니다.', style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}
