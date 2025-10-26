import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MhmShareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label; // <— 新增

  const MhmShareButton({
    super.key,
    required this.onPressed,
    this.label = 'Share Resource', // <— 默认文案
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.mic),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: MhmColors.mint,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}
