class NoteUpdate {
  String? noteTitle;
  String? noteContent;
  NoteUpdate({
    required this.noteTitle,
    required this.noteContent,
  });

  Map<String, dynamic> toJson() {
    return {
      "noteTitle": noteTitle,
      "noteContent": noteContent,
    };
  }
}
