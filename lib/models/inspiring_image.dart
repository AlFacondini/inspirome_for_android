import 'package:intl/intl.dart';

class InspiringImage {
  final String guid;
  final String imageUrl;
  final String? comment;
  final DateTime dateGenerated;
  final bool favourite;

  InspiringImage(this.guid, this.imageUrl, this.comment, this.dateGenerated,
      this.favourite);

  @override
  String toString() {
    String guidBeginning = guid.substring(0, 8);
    String urlEnd = Uri.parse(imageUrl).pathSegments.last;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String formattedDate = dateFormat.format(dateGenerated);
    return "$guidBeginning - $urlEnd - $formattedDate - $favourite";
  }

  InspiringImage withFavourite(bool newFavourite) {
    return InspiringImage(guid, imageUrl, comment, dateGenerated, newFavourite);
  }
}
