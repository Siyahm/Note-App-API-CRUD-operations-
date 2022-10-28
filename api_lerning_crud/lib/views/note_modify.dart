import 'package:api_lerning_crud/models/note_details.dart';
import 'package:api_lerning_crud/models/note_insert.dart';
import 'package:api_lerning_crud/models/note_update.dart';
import 'package:api_lerning_crud/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {
  const NoteModify({
    super.key,
    this.noteID,
  });
  final String? noteID;

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  NoteDetails? note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    if (isEditing) {
      setState(() {
        isLoading = true;
      });
      notesService.getNoteDetails(widget.noteID!).then((response) {
        if (response.error!) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        note = response.data;
        _titleController.text = note!.noteTitle ?? '';
        _contentController.text = note!.noteContent ?? '';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit note' : 'Create New Note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Note Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Note Details'),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (isEditing) {
                    //edit new note
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteUpdate(
                      noteTitle: _titleController.text,
                      noteContent: _contentController.text,
                    );
                    final result =
                        await notesService.updateNote(widget.noteID!, note);

                    setState(() {
                      isLoading = false;
                    });

                    const title = 'Done';
                    final text = result.error!
                        ? (result.errorMessage ?? "An error occured")
                        : 'Your Note was updated';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(title),
                        content: Text(text),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((data) {
                      if (result.data!) {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    //create new note
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteInsert(
                      noteTitle: _titleController.text,
                      noteContent: _contentController.text,
                    );
                    final result = await notesService.createNote(note);

                    setState(() {
                      isLoading = false;
                    });

                    const title = 'Done';
                    final text = result.error!
                        ? (result.errorMessage ?? "An error occured")
                        : 'Your Note was created';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(title),
                        content: Text(text),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((data) {
                      if (result.data!) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
