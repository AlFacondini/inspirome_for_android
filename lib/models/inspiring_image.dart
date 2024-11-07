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
    return "$imageUrl - $dateGenerated - $favourite";
  }

  InspiringImage withFavourite(bool newFavourite) {
    return InspiringImage(guid, imageUrl, comment, dateGenerated, newFavourite);
  }
}
