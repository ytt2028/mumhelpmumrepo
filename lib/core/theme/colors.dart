// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class MhmColors {
  // 背景 & 文字
  static const bg        = Color(0xFFF8F8F8); // #F8F8F8
  static const text      = Color(0xFF333333); // #333333

  // 品牌/强调
  static const coral     = Color(0xFFFF7D7D); // #FF7D7D
  static const accent    = coral;             // 别名，兼容旧代码

  // 主题色
  static const mint      = Color(0xFF5AC8BC); // #5AC8BC

  // 分类卡片色
  static const lightBlue = Color(0xFFA5D8FF); // #A5D8FF
  static const cardHealth= lightBlue;         // 别名，兼容设计命名

  static const lightGreen= Color(0xFFB2EBF2); // #B2EBF2
  static const peach     = Color(0xFFFFC1A1); // #FFC1A1
}
