import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/features/profile/profile_screen.dart';

/// 统一品牌头（保持你原有 API）
class MhmHeader extends StatelessWidget {
  final bool compact;
  final bool showActions;
  final bool showHamburgerLeft;
  final bool showOverflowRight;

  const MhmHeader({
    super.key,
    this.compact = false,
    this.showActions = false,
    this.showHamburgerLeft = true,
    this.showOverflowRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: compact ? 20 : 24,
      color: MhmColors.coral,
      height: 1.0,
    );
    final subStyle = TextStyle(
      fontSize: compact ? 12 : 13,
      color: Colors.black54,
      height: 1.0,
    );

    final user = FirebaseAuth.instance.currentUser;

    Widget avatarButton() {
      if (user == null) {
        return const Icon(Icons.person_outline);
      }
      final letter =
          (user.displayName ?? user.email ?? 'U').trim().characters.first.toUpperCase();
      final photo = user.photoURL;

      final avatar = CircleAvatar(
        radius: compact ? 14 : 16,
        backgroundColor: Colors.black12,
        backgroundImage: photo != null ? NetworkImage(photo) : null,
        child: photo == null
            ? Text(letter, style: const TextStyle(color: Colors.black87))
            : null,
      );

      return PopupMenuButton<String>(
        tooltip: 'Account',
        offset: const Offset(0, 10),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'profile', child: Text('Edit profile')),
          PopupMenuItem(value: 'signout', child: Text('Sign out')),
        ],
        onSelected: (v) async {
          if (v == 'profile') {
            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
          } else if (v == 'signout') {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out')),
              );
            }
          }
        },
        child: avatar,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          if (showHamburgerLeft)
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),

          // 中间 LOGO
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 20, color: MhmColors.coral),
                    const SizedBox(width: 6),
                    Text('MumHelpMum', style: titleStyle),
                  ],
                ),
                const SizedBox(height: 2),
                Text('mumhelpmum.com', style: subStyle),
              ],
            ),
          ),

          if (showActions) ...[
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
              tooltip: 'Notifications',
            ),
            avatarButton(),
          ],

          if (showOverflowRight)
            IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}
