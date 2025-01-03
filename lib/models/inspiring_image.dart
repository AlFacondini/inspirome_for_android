import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inspiring_image.g.dart';

@JsonSerializable()
class InspiringImage implements Comparable<InspiringImage> {
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
  @JsonKey(defaultValue: 1)
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
    return "$guidBeginning - $urlEnd - $formattedDate - $favourite - $score";
  }

  InspiringImage withFavourite(bool newFavourite) {
    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, newFavourite, score, tags);
  }

  InspiringImage withScore(int newScore) {
    int adjustedScore;
    if (newScore > 5) {
      adjustedScore = 5;
    } else if (newScore < 1) {
      adjustedScore = 1;
    } else {
      adjustedScore = newScore;
    }

    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, favourite, adjustedScore, tags);
  }

  InspiringImage withTags(Set<String> newTags) {
    return InspiringImage(
        guid, imageUrl, comment, dateGenerated, favourite, score, newTags);
  }

  factory InspiringImage.fromJson(Map<String, dynamic> json) =>
      _$InspiringImageFromJson(json);

  Map<String, dynamic> toJson() => _$InspiringImageToJson(this);

  @override
  int compareTo(InspiringImage other) {
    final comparisonResult = score.compareTo(other.score);
    if (comparisonResult != 0) {
      return comparisonResult;
    } else {
      return guid.compareTo(other.guid);
    }
  }
}
