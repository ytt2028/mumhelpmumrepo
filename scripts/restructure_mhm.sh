#!/usr/bin/env bash
set -euo pipefail
echo "👉 MumHelpMum structure migration starting..."
if [[ ! -f "pubspec.yaml" ]]; then
  echo "❌ 请在 Flutter 项目根目录运行（未找到 pubspec.yaml）"
  exit 1
fi
mkdir -p lib/features/{shell,hub,events,explore}
mkdir -p lib/core/{theme,widgets}
if [[ -f lib/features/planner/planner_screen.dar ]]; then
  (git rm -f lib/features/planner/planner_screen.dar 2>/dev/null) || rm -f lib/features/planner/planner_screen.dar
fi
mkdir -p lib/_archive
for d in home kids mom; do
  if [[ -d "lib/features/$d" ]]; then
    (git mv "lib/features/$d" "lib/_archive/$d" 2>/dev/null) || mv "lib/features/$d" "lib/_archive/$d"
  fi
done
if [[ -f lib/core/widgets/mhm_segment_tabs.dart ]]; then
  if ! grep -Rqs "mhm_segment_tabs.dart" lib | grep -v "_archive" ; then
    (git mv lib/core/widgets/mhm_segment_tabs.dart lib/_archive/ 2>/dev/null) || mv lib/core/widgets/mhm_segment_tabs.dart lib/_archive/
  fi
fi
if [[ -f lib/core/widgets/mhm_share_button.dart ]]; then
  if ! grep -Rqs "mhm_share_button.dart" lib | grep -v "_archive" ; then
    (git mv lib/core/widgets/mhm_share_button.dart lib/_archive/ 2>/dev/null) || mv lib/core/widgets/mhm_share_button.dart lib/_archive/
  fi
fi
create_stub() {
  local path="$1"; local title="$2";
  if [[ ! -f "$path" ]]; then
    cat > "$path" <<EOF
import 'package:flutter/material.dart';
class ${title} extends StatelessWidget {
  const ${title}({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child:
      Text('$title', style: Theme.of(context).textTheme.headlineSmall),
    )));
  }
}
EOF
  fi
}
create_stub lib/features/hub/hub_screen.dart HubScreen
create_stub lib/features/events/events_screen.dart EventsScreen
create_stub lib/features/explore/explore_screen.dart ExploreScreen
if [[ ! -f lib/features/shell/shell_screen.dart ]]; then
cat > lib/features/shell/shell_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:mumhelpmum/features/hub/hub_screen.dart';
import 'package:mumhelpmum/features/planner/planner_screen.dart';
import 'package:mumhelpmum/features/events/events_screen.dart';
import 'package:mumhelpmum/features/explore/explore_screen.dart';
class ShellScreen extends StatefulWidget { const ShellScreen({super.key}); @override State<ShellScreen> createState()=>_ShellScreenState(); }
class _ShellScreenState extends State<ShellScreen>{
  int _index=0;
  @override Widget build(BuildContext context){
    final pages=const[HubScreen(),PlannerScreen(),EventsScreen(),ExploreScreen()];
    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12,4,12,12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0,8))],
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i)=>setState(()=>_index=i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label:'Mum Help'),
              NavigationDestination(icon: Icon(Icons.local_cafe_outlined), selectedIcon: Icon(Icons.local_cafe), label:'Planner'),
              NavigationDestination(icon: Icon(Icons.campaign_outlined), selectedIcon: Icon(Icons.campaign), label:'Events'),
              NavigationDestination(icon: Icon(Icons.travel_explore_outlined), selectedIcon: Icon(Icons.travel_explore), label:'Explore'),
            ],
          ),
        ),
      ),
    );
  }
}
EOF
fi
if ! grep -q "ShellScreen" lib/main.dart 2>/dev/null; then
  if [[ -f lib/main.dart ]]; then cp lib/main.dart lib/main.dart.bak; fi
  cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:mumhelpmum/features/shell/shell_screen.dart';
void main(){runApp(const MaterialApp(debugShowCheckedModeBanner:false,home: ShellScreen()));}
EOF
fi
( command -v tree >/dev/null 2>&1 && tree -L 3 lib ) || find lib -maxdepth 3 -print
if [[ -d .git ]]; then git add -A; git commit -m "chore(structure): scaffold new screens & shell; archive legacy" || true; fi
echo "✅ Done. Next: flutter pub get && flutter run -d chrome"
