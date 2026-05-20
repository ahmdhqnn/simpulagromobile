import '../../domain/entities/reaction.dart';
import 'json_parser.dart';

/// Data Model: Reaction
/// Extends Entity dan menambahkan serialization logic.
/// API Response: { user_id, user_name, user_avatar }
/// Robust terhadap variasi response API (type casting safe).
class ReactionModel extends Reaction {
  const ReactionModel({
    required super.userId,
    required super.userName,
    super.userAvatar,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_id', 'id']),
      ),
      userName: JsonParser.parseString(
        JsonParser.tryKeys(json, ['user_name', 'username', 'name']),
        defaultValue: 'Unknown User',
      ),
      userAvatar: JsonParser.parseStringOrNull(
        JsonParser.tryKeys(json, ['user_avatar', 'avatar', 'avatar_url']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
    };
  }
}
