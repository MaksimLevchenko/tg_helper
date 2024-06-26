import 'package:meta/meta.dart';
import '../extensions/data_class_extensions.dart';
import '../tdapi.dart';

/// Check the authentication code and completes the request for which the code
/// was sent if appropriate
/// Returns [Ok]
@immutable
class CheckPhoneNumberCode extends TdFunction {
  const CheckPhoneNumberCode({
    required this.code,
  });

  /// [code] Authentication code to check
  final String code;

  static const String constructor = 'checkPhoneNumberCode';

  @override
  String getConstructor() => constructor;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        '@type': constructor,
      };

  @override
  bool operator ==(Object other) => overriddenEquality(other);

  @override
  int get hashCode => overriddenHashCode;
}
