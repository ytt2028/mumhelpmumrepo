// lib/features/hub/hub_screen.dart
import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const posts = _demoPosts;

    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // 统一品牌头（Hub 需要铃铛 & 头像）
            const MhmHeader(
              title: 'MumHelpMum',
              subtitle: 'mumhelpmum.com',
              showMenuLeft: true,
              showMenuRight: false,
              showBell: true,
              showProfile: true,
              centerBrand: true,
            ),
            const SizedBox(height: 8),

            // “热点分栏”标题（示例）
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                '热点分栏',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),

            // 帖子列表
            ...posts.map((p) => _PostCard(post: p)).toList(),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// Model & demo data
/// ---------------------------

class Post {
  final String author;
  final String time; // e.g. '5分钟前'
  final String content;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final String? imageUrl;

  const Post({
    required this.author,
    required this.time,
    required this.content,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.shares,
    this.imageUrl,
  });
}

const _demoPosts = <Post>[
  Post(
    author: '乐乐妈',
    time: '5分钟前',
    content:
        '今天有皇皇为子新桦亚游场，\n一工是放电相柞！ 压维椅\n强推荐！',
    tags: ['#室内活动', '#亲子乐园', '#翊洪好跋提'],
    likes: 25,
    comments: 18,
    shares: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1501706362039-c06b2d715385?w=800&q=80',
  ),
  Post(
    author: '小北妈',
    time: '2小时前',
    content:
        '与宝最好友爱食饪，拌逗下西稞\n肥绵腻㤿！ 现场直播分了 😋',
    tags: ['#食郅分享', '#终安家', '#拼赤旱皇'],
    likes: 3,
    comments: 12,
    shares: 1,
    imageUrl:
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80',
  ),
  Post(
    author: '晨秩爸',
    time: '1天前',
    content:
        '投劝哔断早蛰中 的 免兔抹抹饪糊\n扶侍樽！ 名想活有， 早敳快帍！\n地址：未来龙A生，根时3斌',
    tags: ['#地址', '#晨起分享'],
    likes: 9,
    comments: 6,
    shares: 0,
    imageUrl:
        'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800&q=80',
  ),
];

/// ---------------------------
/// UI
/// ---------------------------

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像 + 名称 + 时间 + 右侧缩略图
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: MhmColors.lightGreen,
                child: Text(
                  post.author.characters.first,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称 + 时间
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.author,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          post.time,
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(post.content),
                    const SizedBox(height: 6),
                    // 标签
                    Wrap(
                      spacing: 8,
                      runSpacing: -6,
                      children: post.tags
                          .map(
                            (t) => Chip(
                              label: Text(t),
                              backgroundColor: Colors.grey.shade100,
                              side: const BorderSide(color: Colors.black26),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              if (post.imageUrl != null) ...[
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrl!,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 10),

          // 操作行：创建活动 / 收藏 / 评论 / 点赞 / 转发
          Row(
            children: [
              _actionButton(Icons.event_outlined, '创活动'),
              const SizedBox(width: 12),
              _actionButton(Icons.bookmark_border, '收藏'),
              const Spacer(),
              _iconStat(Icons.mode_comment_outlined, post.comments),
              const SizedBox(width: 12),
              _iconStat(Icons.favorite_border, post.likes),
              const SizedBox(width: 12),
              _iconStat(Icons.reply_outlined, post.shares),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _iconStat(IconData icon, int n) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black45),
        const SizedBox(width: 4),
        Text('$n', style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
