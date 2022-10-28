class NotesModelsForListing {
  String? noteID;
  String? noteTitle;
  DateTime? createDateTime;
  DateTime? lastEditedDateTime;

  NotesModelsForListing({
    this.noteID,
    this.noteTitle,
    this.createDateTime,
    this.lastEditedDateTime,
  });

  factory NotesModelsForListing.fromJson(Map<String, dynamic> item) {
    return NotesModelsForListing(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      lastEditedDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
