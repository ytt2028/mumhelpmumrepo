import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/state/feed_state.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';
import 'package:mumhelpmum/features/hub/post_model.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  final _search = TextEditingController();

  // 时间筛选
  final List<String> _timeFilters = const ['Latest', 'This Week', 'This Month'];
  String _timeSelected = 'Latest';

  // 关注分类（两行 + More/Less）
  static const List<String> _allCategories = [
    'playground','indoor','stroller friendly','fenced','shaded','park','rainy day',
    'library','storytime','museum','science centre','zoo','aquarium','art & craft',
    'music class','swimming','playgroup','gym',
    'kids friendly restaurant','cafe','weekend trip',
    'nap tips','sleep training','potty training','meal ideas','breastfeeding',
    'postpartum','mental health',
    'free','group buy','promotions','deals','birthday ideas',
  ];
  bool _showAllCats = false;
  static const int _twoRowCount = 10;
  final Set<String> _selectedCats = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Post>>(
      valueListenable: FeedState.I.feed,
      builder: (context, feed, _) {
        final filtered = _filtered(feed);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 顶部品牌条：右上角头像 + 铃铛
              const MhmHeader(compact: true, showActions: true),

              // 搜索
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search posts / places / tags…',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 时间筛选
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: _timeFilters.map((t) {
                    final sel = _timeSelected == t;
                    return ChoiceChip(
                      label: Text(t),
                      selected: sel,
                      onSelected: (_) => setState(() => _timeSelected = t),
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                      selectedColor: MhmColors.mint,
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(color: sel ? MhmColors.mint : Colors.black26),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 6),

              // 话题分类（两行 + More/Less）
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...(_showAllCats ? _allCategories : _allCategories.take(_twoRowCount))
                        .map((c) => FilterChip(
                              label: Text(c),
                              selected: _selectedCats.contains(c),
                              onSelected: (v) {
                                setState(() {
                                  if (v) {
                                    _selectedCats.add(c);
                                  } else {
                                    _selectedCats.remove(c);
                                  }
                                });
                              },
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                color: _selectedCats.contains(c) ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              selectedColor: MhmColors.mint,
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: _selectedCats.contains(c)
                                      ? MhmColors.mint
                                      : Colors.black26,
                                ),
                              ),
                            )),
                    if (!_showAllCats && _allCategories.length > _twoRowCount)
                      ActionChip(
                        label: const Text('More'),
                        onPressed: () => setState(() => _showAllCats = true),
                      ),
                    if (_showAllCats)
                      ActionChip(
                        label: const Text('Less'),
                        onPressed: () => setState(() => _showAllCats = false),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 帖子列表
              ...filtered.map((p) => _PostCard(post: p)).toList(),
            ],
          ),
        );
      },
    );
  }

  List<Post> _filtered(List<Post> posts) {
    final q = _search.text.trim().toLowerCase();

    bool inTime(Post p) {
      final now = DateTime.now();
      switch (_timeSelected) {
        case 'This Week':
          return p.createdAt.isAfter(now.subtract(const Duration(days: 7)));
        case 'This Month':
          return p.createdAt.isAfter(now.subtract(const Duration(days: 30)));
        default:
          return true;
      }
    }

    final list = posts.where((p) {
      final contentHit = q.isEmpty ||
          p.content.toLowerCase().contains(q) ||
          p.author.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
      final catsHit = _selectedCats.isEmpty ||
          p.tags.any((t) => _selectedCats.any((sel) => t.toLowerCase().contains(sel.toLowerCase())));
      return contentHit && catsHit && inTime(p);
    }).toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}

/// ---------------------------
/// UI: 帖子卡片
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像 + 名称 + 时间 + 右图
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: MhmColors.lightGreen,
                child: Text(
                  post.authorInitial,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(post.content),
                    const SizedBox(height: 10),

                    // 标签（#开头，行间距更舒适）
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.tags
                          .map((t) => _TagChip(text: '#${t[0].toUpperCase()}${t.substring(1)}'))
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

          const SizedBox(height: 12),

          // 操作行：Create event / Save + 右侧统计（自适应换行，不再挤压）
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _actionButton(Icons.event_outlined, 'Create event'),
              _actionButton(Icons.bookmark_border, 'Save'),
              _StatGroup(
                comments: post.comments,
                likes: post.likes,
                shares: post.shares,
              ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _StatGroup extends StatelessWidget {
  const _StatGroup({required this.comments, required this.likes, required this.shares});
  final int comments;
  final int likes;
  final int shares;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconStat(Icons.mode_comment_outlined, comments),
        const SizedBox(width: 12),
        _iconStat(Icons.favorite_border, likes),
        const SizedBox(width: 12),
        _iconStat(Icons.reply_outlined, shares),
      ],
    );
  }

  Widget _iconStat(IconData icon, int n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black45),
        const SizedBox(width: 4),
        Text('$n', style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey.shade100,
      side: const BorderSide(color: Colors.black26),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      labelStyle: const TextStyle(fontSize: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
