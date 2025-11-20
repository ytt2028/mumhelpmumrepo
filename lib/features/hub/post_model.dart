import 'package:flutter/material.dart';

class Post {
  final String author;
  final DateTime createdAt;
  final String content;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final String? imageUrl;

  const Post({
    required this.author,
    required this.createdAt,
    required this.content,
    required this.tags,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.imageUrl,
  });

  String get timeAgo {
    final d = DateTime.now().difference(createdAt);
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} hours ago';
    return '${d.inDays} day${d.inDays > 1 ? 's' : ''} ago';
  }

  String get authorInitial => author.characters.first;
}
