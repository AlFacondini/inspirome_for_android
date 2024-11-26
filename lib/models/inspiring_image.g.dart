// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspiring_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspiringImage _$InspiringImageFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['guid', 'imageUrl', 'dateGenerated', 'favourite'],
  );
  return InspiringImage(
    json['guid'] as String,
    json['imageUrl'] as String,
    json['comment'] as String? ?? '',
    DateTime.parse(json['dateGenerated'] as String),
    json['favourite'] as bool,
    (json['score'] as num?)?.toInt() ?? 1,
    (json['tags'] as List<dynamic>).map((e) => e as String).toSet(),
  );
}

Map<String, dynamic> _$InspiringImageToJson(InspiringImage instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'imageUrl': instance.imageUrl,
      'comment': instance.comment,
      'dateGenerated': instance.dateGenerated.toIso8601String(),
      'favourite': instance.favourite,
      'score': instance.score,
      'tags': instance.tags.toList(),
    };
