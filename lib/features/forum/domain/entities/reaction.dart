/// Domain Entity: Reaction (Who Liked)
/// Pure Dart class, no dependencies
class Reaction {
  final String userId;
  final String userName;
  final String? userAvatar;
  final DateTime reactedAt;

  const Reaction({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.reactedAt,
  });
}
