import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inspiring_image.g.dart';

@JsonSerializable()
class InspiringImage {
  @JsonKey(required: true)
  final String guid;
  @JsonKey(required: true)
  final String imageUrl;
  @JsonKey(defaultValue: "")
  final String? comment;
  @JsonKey(required: true)
  final DateTime dateGenerated;
  @JsonKey(required: true)
  final bool favourite;
  @JsonKey(defaultValue: 0)
  final int score;
  @JsonKey()
  final Set<String> tags;

  InspiringImage(this.guid, this.imageUrl, this.comment, this.dateGenerated,
      this.favourite, this.score, this.tags);

  @override
  String toString() {
    String guidBeginning = guid.substring(0, 8);
    String urlEnd = Uri.parse(imageUrl).pathSegments.last;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String formattedDate = dateFormat.format(dateGenerated);
    return "$guidBeginning - $urlEnd - $formattedDate - $favourite";
  }

  InspiringImage withFavourite(bool newFavourite) {
    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, newFavourite, score, tags);
  }

  InspiringImage withScore(int newScore) {
    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, favourite, newScore, tags);
  }

  InspiringImage withTags(Set<String> newTags) {
    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, favourite, score, newTags);
  }

  factory InspiringImage.fromJson(Map<String, dynamic> json) =>
      _$InspiringImageFromJson(json);

  Map<String, dynamic> toJson() => _$InspiringImageToJson(this);
}
