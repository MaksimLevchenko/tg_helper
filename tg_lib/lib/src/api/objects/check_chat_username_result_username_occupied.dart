import 'package:meta/meta.dart';
import '../extensions/data_class_extensions.dart';
import '../tdapi.dart';

/// The username is occupied
@immutable
class CheckChatUsernameResultUsernameOccupied extends CheckChatUsernameResult {
  const CheckChatUsernameResultUsernameOccupied();

  static const String constructor = 'checkChatUsernameResultUsernameOccupied';

  static CheckChatUsernameResultUsernameOccupied? fromJson(
      Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return const CheckChatUsernameResultUsernameOccupied();
  }

  @override
  String getConstructor() => constructor;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        '@type': constructor,
      };

  @override
  bool operator ==(Object other) => overriddenEquality(other);

  @override
  int get hashCode => overriddenHashCode;
}
