import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/theme/colors.dart';
import '../../core/widgets/mhm_card.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final List<_Activity> _activities = [
    _Activity('Playgroup at 10 AM', true),
    _Activity('Library Storytime at 2 PM', true),
  ];

  // 秒表 & Ticker
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  String get _hhmmss {
    final e = _stopwatch.elapsed;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(e.inHours)}:${two(e.inMinutes % 60)}:${two(e.inSeconds % 60)}';
  }
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {});
    });
  }
  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  // 语音
  final stt.SpeechToText _stt = stt.SpeechToText();
  bool _listening = false;

  Future<void> _generateToday() async {
    // 模拟“生成今日行程” + 语音状态
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _startTicker();
    }
    final ok = await _stt.initialize(onStatus: (_) {}, onError: (_) {});
    if (ok) {
      setState(() => _listening = true);
      await _stt.listen(
        partialResults: true,
        localeId: 'en-NZ', // 要中文改 'zh-CN'
        onResult: (r) {
          // Demo：把识别到的一句简单加进活动
          final words = r.recognizedWords.trim();
          if (words.isNotEmpty && words.split(' ').length > 2) {
            setState(() => _activities.add(_Activity(words, false)));
          }
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      await _stt.stop();
      setState(() => _listening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generated today’s itinerary (demo)')),
      );
    }
  }

  void _resetTimer() {
    _stopwatch
      ..stop()
      ..reset();
    _stopTicker();
    setState(() {});
  }

  void _quickStart(int minutes) {
    _resetTimer();
    _stopwatch.start();
    _startTicker();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Started ${minutes}m timer (demo)')),
    );
  }

  @override
  void dispose() {
    _stopTicker();
    _stt.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final header =
        '${_weekday(now.weekday).toUpperCase()}, ${_month(now.month).toUpperCase()} ${now.day}';

    return Column(
      children: [
        const SizedBox(height: 8),
        // 品牌条（与图一致）
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.menu),
              const Spacer(),
              const Icon(Icons.favorite, color: MhmColors.accent),
              const SizedBox(width: 6),
              Text('MumHelpMum', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800, color: MhmColors.accent,
              )),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        Text('mumhelpmum.com',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 12),

        // 日期
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Today, $header',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 8),

        // 内容
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Daily Activities（蓝卡，内部清单）
              MhmCard(
                background: MhmColors.cardHealth.withOpacity(.8),
                leading: const Icon(Icons.check_circle_outline, size: 28),
                title: 'Daily Activities',
                trailing: _RoundIcon(
                  icon: Icons.add,
                  onTap: () async {
                    final t = await _addDialog();
                    if (t != null) setState(() => _activities.add(_Activity(t, false)));
                  },
                ),
                body: Column(
                  children: _activities.asMap().entries.map((e) {
                    final idx = e.key;
                    final item = e.value;
                    return InkWell(
                      onTap: () => setState(() => item.done = !item.done),
                      onLongPress: () => _confirmDelete(idx),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                        child: Row(
                          children: [
                            Icon(item.done ? Icons.check_box : Icons.check_box_outline_blank, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  decoration: item.done ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Nap/Focus Timer（薄荷绿）
              Container(
                decoration: BoxDecoration(
                  color: MhmColors.mint.withOpacity(.75),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,6))],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text('Nap/Focus Timer',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(_hhmmss,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800, color: Colors.black87)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _pill('15m', () => _quickStart(15)),
                        _pill('30m', () => _quickStart(30)),
                        _pill('45m', () => _quickStart(45)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 底部两个按钮：生成今日行程 + Reset
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _generateToday,
                        icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                        label: Text(_listening ? "Generating…" : "Generate Today's Itinerary"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MhmColors.mint, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _resetTimer,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, foregroundColor: Colors.black87,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  Future<String?> _addDialog() async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Activity'),
        content: TextField(controller: c, decoration: const InputDecoration(hintText: 'e.g., Nap at 1:30 PM')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('Add')),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text(_activities[index].title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) setState(() => _activities.removeAt(index));
  }

  String _weekday(int w) =>
      ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][w - 1];
  String _month(int m) =>
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 22)),
      ),
    );
  }
}

class _Activity {
  final String title;
  bool done;
  _Activity(this.title, this.done);
}
