import 'package:meta/meta.dart';
import '../extensions/data_class_extensions.dart';
import '../tdapi.dart';

/// The default background has changed
@immutable
class UpdateDefaultBackground extends Update {
  const UpdateDefaultBackground({
    required this.forDarkTheme,
    this.background,
  });

  /// [forDarkTheme] True, if default background for dark theme has changed
  final bool forDarkTheme;

  /// [background] The new default background; may be null
  final Background? background;

  static const String constructor = 'updateDefaultBackground';

  static UpdateDefaultBackground? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return UpdateDefaultBackground(
      forDarkTheme: json['for_dark_theme'] as bool,
      background:
          Background.fromJson(json['background'] as Map<String, dynamic>?),
    );
  }

  @override
  String getConstructor() => constructor;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'for_dark_theme': forDarkTheme,
        'background': background?.toJson(),
        '@type': constructor,
      };

  @override
  bool operator ==(Object other) => overriddenEquality(other);

  @override
  int get hashCode => overriddenHashCode;
}
