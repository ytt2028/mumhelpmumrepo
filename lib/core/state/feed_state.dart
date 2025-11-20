import 'package:flutter/foundation.dart';
import 'package:mumhelpmum/features/hub/post_model.dart';

class FeedState {
  FeedState._();
  static final FeedState I = FeedState._();

  // 初始演示数据（英文）
  final ValueNotifier<List<Post>> feed = ValueNotifier<List<Post>>([
    Post(
      author: "Lele's Mum",
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      content:
          "We went to the new Xinhua Kids Park this morning.\n"
          "Perfect place for the little one to burn energy! The bouncy seats were a hit.\n"
          "Highly recommend!",
      tags: ['indoor', 'kids playground', 'must try'],
      likes: 25, comments: 18, shares: 5,
      imageUrl: 'https://images.unsplash.com/photo-1501706362039-c06b2d715385?w=800&q=80',
    ),
    Post(
      author: "Xiaobei's Mum",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      content:
          "Our kid loves cooking together. Today we mashed avocado and pumpkin — super creamy!\n"
          "Did a quick live demo 😋",
      tags: ['food share', 'healthy eating', 'toddler breakfast'],
      likes: 3, comments: 12, shares: 1,
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80',
    ),
    Post(
      author: 'Morning Dad',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      content:
          "Sharing our quick oat-porridge breakfast for busy mornings.\n"
          "Filling and keeps everyone energized!\n"
          "Location: Future Dragon Ave, Block A, Unit 3 (demo)",
      tags: ['location', 'morning share'],
      likes: 9, comments: 6, shares: 0,
      imageUrl: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800&q=80',
    ),
  ]);

  void add(Post p) {
    final next = [...feed.value];
    next.insert(0, p);              // 新内容置顶
    feed.value = next;
  }
}
