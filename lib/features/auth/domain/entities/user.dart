class User {
  final String userId;
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final String? userSts;
  final String? roleId;

  const User({
    required this.userId,
    required this.userName,
    this.userEmail,
    this.userPhone,
    this.userSts,
    this.roleId,
  });

  bool get isAdmin => roleId == 'ROLE001';
  bool get isActive => userSts == 'active';
}
