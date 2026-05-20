class Reaction {
  final String userId;
  final String userName;
  final String? userAvatar;

  const Reaction({
    required this.userId,
    required this.userName,
    this.userAvatar,
  });
}
