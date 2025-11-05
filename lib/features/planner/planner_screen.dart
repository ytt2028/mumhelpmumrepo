// lib/features/planner/planner_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_card.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  // 今日活动清单（蓝色卡片里的内容）
  final List<_Activity> _activities = [
    _Activity('Playgroup at 10 AM', true),
    _Activity('Library Storytime at 2 PM', true),
  ];

  // —— 秒表 & 计时刷新 —— //
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  String get _hhmmss {
    final e = _stopwatch.elapsed;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(e.inHours)}:${two(e.inMinutes % 60)}:${two(e.inSeconds % 60)}';
    // 00:00:00 形式
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

  // —— 语音 —— //
  final stt.SpeechToText _stt = stt.SpeechToText();
  bool _listening = false;

  Future<void> _generateToday() async {
    // Demo：开始计时 & 语音听写，把识别到的一句较完整的话加入活动清单
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _startTicker();
    }

    final ok = await _stt.initialize(onStatus: (_) {}, onError: (_) {});
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Microphone unavailable')));
      return;
    }

    setState(() => _listening = true);

    await _stt.listen(
      partialResults: true,
      localeId: 'en-NZ', // 改中文可用 'zh-CN'
      onResult: (r) {
        final words = r.recognizedWords.trim();
        // 仅当识别到“看起来像一句话”时添加
        if (words.isNotEmpty && words.split(' ').length > 2) {
          setState(() => _activities.add(_Activity(words, false)));
        }
      },
    );

    // 简化：监听 2 秒后停止
    await Future.delayed(const Duration(seconds: 2));
    await _stt.stop();
    setState(() => _listening = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generated today’s itinerary (demo)')),
    );
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

    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: Column(
        children: [
          // —— 统一品牌头（Planner 版：无铃铛&头像） —— //
          const MhmHeader(
            title: 'MumHelpMum',
            subtitle: 'mumhelpmum.com',
            showMenuLeft: true,
            showMenuRight: false,
            showBell: false,
            showProfile: false,
            centerBrand: true,
          ),
          const SizedBox(height: 8),

          // 日期标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Today, $header',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 主体滚动区
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // —— Daily Activities（蓝色卡片，内部是清单） —— //
                MhmCard(
                  background: MhmColors.cardHealth.withOpacity(.8), // #A5D8FF
                  leading: const Icon(Icons.check_circle_outline, size: 28),
                  title: 'Daily Activities',
                  trailing: _RoundIcon(
                    icon: Icons.add,
                    onTap: () async {
                      final t = await _addDialog();
                      if (t != null) {
                        setState(() => _activities.add(_Activity(t, false)));
                      }
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
                              Icon(
                                item.done
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    decoration: item.done
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
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

                // —— Nap/Focus Timer（薄荷绿卡片） —— //
                Container(
                  decoration: BoxDecoration(
                    color: MhmColors.mint.withOpacity(.75),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        'Nap/Focus Timer',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _hhmmss,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.black87),
                      ),
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

                // —— 底部两个按钮：语音生成 + Reset —— //
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _generateToday,
                          icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                          label: Text(_listening
                              ? 'Generating…'
                              : "Generate Today's Itinerary"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MhmColors.mint,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
      ),
    );
  }

  // —— UI 小组件 —— //
  Widget _pill(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  // —— 弹框：添加活动 —— //
  Future<String?> _addDialog() async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Activity'),
        content: TextField(
          controller: c,
          decoration:
              const InputDecoration(hintText: 'e.g., Nap at 1:30 PM'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // —— 长按删除确认 —— //
  Future<void> _confirmDelete(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text(_activities[index].title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _activities.removeAt(index));
    }
  }

  // —— 日期格式工具 —— //
  String _weekday(int w) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];
  String _month(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];
}

// —— 小圆形图标按钮（卡片右上角 +） —— //
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
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}

// —— 活动模型 —— //
class _Activity {
  final String title;
  bool done;
  _Activity(this.title, this.done);
}
