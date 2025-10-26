# MumHelpMum (Flutter MVP)

A minimal, calm, **voice-first** parenting helper for busy mums.  
This MVP includes **Kids**, **Mom**, and **Planner** pages with a consistent design system and basic voice input on Planner.

> Tech: Flutter, Google Fonts, (optional) Riverpod, `speech_to_text` for voice input.

---

## ✨ Features (MVP)
- **Kids / Mom / Planner** 3 sections with segmented tabs
- Reusable **card** components and a sticky **Share/Voice** button
- **Voice input** on Planner (Web ready; iOS/Android permissions noted below)
- Centralized **theme & color tokens** for consistent UI

---

## 🎨 Design Tokens
- **Background**: `#F8F8F8`
- **Accent (logo/active tab)**: `#FF7D7D`
- **Mint/Teal (action)**: `#5AC8BC`
- **Card — Health & Wellness**: `#A5D8FF`
- **Card — Support Groups**: `#B2EBF2`
- **Card — Local Activities**: `#FFC1A1`
- **Text (dark)**: `#333333`

---

## 📁 Project Structure
lib/
main.dart
core/
theme/
colors.dart # color tokens
app_theme.dart # global ThemeData (M3, fonts, cards)
widgets/
mhm_card.dart # rounded card with icon + lines
mhm_share_button.dart # bottom CTA (supports custom label)
mhm_segment_tabs.dart # Kids / Mom / Planner segmented control
features/
home/home_screen.dart # header + segmented tabs + page switch
kids/kids_screen.dart # 3 demo cards
mom/mom_screen.dart # 3 demo cards
planner/planner_screen.dart # list + voice draft + bottom voice button
assets/ # (placeholder for future images/icons)


---

## 🧰 Prerequisites
- Flutter SDK (stable) — `flutter doctor` should be mostly green
- For **Web** preview: Chrome
- For **iOS**: Xcode + Simulator runtime
- For **Android**: Android Studio + SDK (optional for now)

---

## 🚀 Getting Started

```bash
# 1) Fetch deps
flutter pub get

# 2) Run on Web (easiest to preview UI)
flutter run -d chrome


