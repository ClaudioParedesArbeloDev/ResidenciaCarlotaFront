import 'package:flutter/material.dart';


class HomeAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;

  const HomeAvatar({
    super.key,
    this.avatarUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl!),
        onBackgroundImageError: (exception, stackTrace) {},
        backgroundColor: Colors.white.withValues(alpha: 0.10),
      );
    }
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Icon(
        Icons.person_outline_rounded,
        color: Colors.white.withValues(alpha: 0.75),
        size: radius * 0.9,
      ),
    );
  }
}
