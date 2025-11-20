import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';

/// 底部发帖面板（轻量版，无第三方依赖）
/// - 支持拖拽展开/收起
/// - 文本内容、多选话题、图片 URL 预览
/// - 点击发布后通过 Navigator.pop 返回一个 map（可用于后续真正落库）
///
/// 你可以在调用处：
/// final data = await showModalBottomSheet(...);
/// if (data != null) { /* 把 data 落库/加入 feed */ }
class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _content = TextEditingController();
  final _imageUrl = TextEditingController();

  // 常用话题
  static const _topics = <String>[
    'indoor',
    'kids playground',
    'must try',
    'food share',
    'healthy eating',
    'toddler breakfast',
    'playgroup',
    'rainy day',
  ];
  final Set<String> _selected = {};

  @override
  void dispose() {
    _content.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // 点空白不透传，避免误触关闭
      onTap: () {},
      child: Container(
        // 半透明背景
        color: Colors.black.withOpacity(0.3),
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // drag handle
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('Create Post',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            )),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 可滚动内容
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: [
                        // 文本内容
                        TextField(
                          controller: _content,
                          maxLines: 6,
                          minLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Share something helpful to other mums…',
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 话题
                        Text('Topics', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _topics
                              .map(
                                (t) => FilterChip(
                                  label: Text(t),
                                  selected: _selected.contains(t),
                                  onSelected: (v) => setState(() {
                                    v ? _selected.add(t) : _selected.remove(t);
                                  }),
                                  showCheckmark: false,
                                  labelStyle: TextStyle(
                                    color: _selected.contains(t) ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  selectedColor: MhmColors.mint,
                                  backgroundColor: Colors.white,
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: _selected.contains(t)
                                          ? MhmColors.mint
                                          : Colors.black26,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),

                        // 图片 URL（可选）
                        Text('Image (URL, optional)', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _imageUrl,
                          decoration: InputDecoration(
                            hintText: 'https://example.com/photo.jpg',
                            prefixIcon: const Icon(Icons.link),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        _preview(),

                        const SizedBox(height: 80), // 给底部按钮留白
                      ],
                    ),
                  ),

                  // 底部操作条
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton.icon(
                                onPressed: _onPublish,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MhmColors.coral,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: const Icon(Icons.send),
                                label: const Text('Publish'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _preview() {
    final url = _imageUrl.text.trim();
    final looksUrl = Uri.tryParse(url)?.hasAbsolutePath == true;
    if (!looksUrl) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Text('Failed to load preview'),
          ),
        ),
      ),
    );
  }

  void _onPublish() {
    final text = _content.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before publishing.')),
      );
      return;
    }

    final data = {
      'content': text,
      'tags': _selected.toList(),
      'imageUrl': _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    // 返回给调用方（可用于加入 feed / Firestore）
    Navigator.pop(context, data);
  }
}
