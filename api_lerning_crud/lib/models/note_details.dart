class NoteDetails {
  String noteID;
  String? noteTitle;
  String? noteContent;
  DateTime? createDateTime;
  DateTime? lastEditedDateTime;

  NoteDetails({
    required this.noteID,
    this.noteTitle,
    this.noteContent,
    this.createDateTime,
    this.lastEditedDateTime,
  });

  factory NoteDetails.fromJson(Map<String, dynamic> json) {
    return NoteDetails(
      noteID: json['noteID'] ?? "",
      noteTitle: json['noteTitle'],
      noteContent: json['noteContent'],
      createDateTime: DateTime.parse(json['createDateTime']),
      lastEditedDateTime: json['latestEditDateTime'] != null
          ? DateTime.parse(json['latestEditDateTime'])
          : null,
    );
  }
}
