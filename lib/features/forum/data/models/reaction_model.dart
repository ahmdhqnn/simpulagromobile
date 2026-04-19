import '../../domain/entities/reaction.dart';

/// Data Model: Reaction
/// Extends Entity dan menambahkan serialization logic
class ReactionModel extends Reaction {
  const ReactionModel({
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.reactedAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? 'Unknown User',
      userAvatar: json['user_avatar'],
      reactedAt: json['reacted_at'] != null
          ? DateTime.parse(json['reacted_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'reacted_at': reactedAt.toIso8601String(),
    };
  }
}
