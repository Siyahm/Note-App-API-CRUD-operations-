import 'dart:developer';

import 'package:api_lerning_crud/services/note_service.dart';
import 'package:api_lerning_crud/views/note_delete.dart';
import 'package:api_lerning_crud/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Notes extends StatelessWidget {
  Notes({super.key});
  bool isLoading = false;

  String formatedDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  NotesService get notesService => GetIt.I<NotesService>();

  @override
  Widget build(BuildContext context) {
    log("build called");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotesService().getNotesList();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NoteModify(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: NotesService().getNotesList(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.error!) {
            return Center(
              child: Text(snapshot.data!.errorMessage!),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Colors.black,
            ),
            itemBuilder: (context, index) {
              // print(_apiResponse?.data?[index].noteId);
              return Dismissible(
                key: ValueKey(snapshot.data?.data![index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final newContext = ScaffoldMessenger.of(context);
                  final result = await showDialog(
                    context: context,
                    builder: (_) => const NoteDelete(),
                  );

                  if (result) {
                    final deleteresult = await notesService
                        .deleteNote(snapshot.data?.data![index].noteID ?? '');

                    String message;

                    if (deleteresult.data == true) {
                      message = 'The note is deleted succesfully';
                    } else {
                      message = deleteresult.errorMessage ?? 'An error occured';
                    }
                    newContext.showSnackBar(
                      SnackBar(
                        content: Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                        duration: const Duration(milliseconds: 1000),
                      ),
                    );
                    return deleteresult.data;
                  }
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    snapshot.data!.data?[index].noteTitle ?? 'No title',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  subtitle: Text(
                    'Last edited on ${formatedDateTime(snapshot.data!.data![index].lastEditedDateTime ?? snapshot.data!.data![index].createDateTime!)}',
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NoteModify(
                          noteID: snapshot.data!.data?[index].noteID,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: snapshot.data!.data!.length,
          );
        },
      ),
    );
  }
}
