import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/theme/colors.dart';
import '../../core/widgets/mhm_card.dart';
import '../../core/widgets/mhm_share_button.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final stt.SpeechToText _stt = stt.SpeechToText();
  bool _isListening = false;
  String _voiceDraft = '';

  Future<void> _toggleListen() async {
    if (!_isListening) {
      final available = await _stt.initialize(
        onStatus: (s) {
          // web/移动端在结束时会回调 notListening/done
          if (s.contains('notListening') || s.contains('done')) {
            setState(() => _isListening = false);
          }
        },
        onError: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mic error: ${e.errorMsg}')),
          );
          setState(() => _isListening = false);
        },
      );
      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone not available / permission denied')),
        );
        return;
      }
      setState(() => _isListening = true);
      await _stt.listen(
        onResult: (result) {
          setState(() => _voiceDraft = result.recognizedWords);
        },
        localeId: 'en-NZ', // 需要中文可改 'zh-CN'/'zh-TW'
        partialResults: true,
      );
    } else {
      await _stt.stop();
      setState(() => _isListening = false);
      if (_voiceDraft.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Captured: $_voiceDraft')),
        );
      }
    }
  }

  @override
  void dispose() {
    _stt.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final label = '${_weekday(now.weekday).toUpperCase()} '
        '${_month(now.month).toUpperCase()} ${now.day}';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 16),
              Text('TODAY, $label',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const MhmCard(
                background: MhmColors.cardHealth,
                leading: Icon(Icons.check_circle_outline, size: 36),
                title: 'Daily Activities',
                lines: ['✓ Playgroup at 10 AM', '✓ Library Storytime at 2 PM'],
              ),
              const SizedBox(height: 14),
              const MhmCard(
                background: MhmColors.cardActivities,
                leading: Icon(Icons.restaurant_menu, size: 36),
                title: 'Recipes',
                lines: ['• Chicken Stir-Fry', '• Banana Bread'],
              ),
              const SizedBox(height: 14),
              const MhmCard(
                background: MhmColors.cardSupport,
                leading: Icon(Icons.timer_outlined, size: 36),
                title: 'Timer',
                lines: ['00:00:00', ''],
              ),
              const SizedBox(height: 14),
              if (_voiceDraft.isNotEmpty)
                MhmCard(
                  background: MhmColors.cardSupport,
                  leading: const Icon(Icons.mic_none, size: 36),
                  title: 'Voice Note (draft)',
                  lines: [_voiceDraft],
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        // 底部语音按钮
        MhmShareButton(
          onPressed: _toggleListen,
          label: _isListening ? 'Listening… Tap to stop' : 'Add by Voice',
        ),
      ],
    );
  }

  String _weekday(int w) =>
      ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][w - 1];
  String _month(int m) =>
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}
