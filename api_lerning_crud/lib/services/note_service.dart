import 'dart:convert';

import 'package:api_lerning_crud/models/api_response.dart';
import 'package:api_lerning_crud/models/note_details.dart';
import 'package:api_lerning_crud/models/note_insert.dart';
import 'package:api_lerning_crud/models/note_update.dart';
import 'package:api_lerning_crud/models/notes_models_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {
  static const api = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';

  static const header = {
    'apiKey': 'ef5f06f6-d69f-4930-b581-78f87522b3a1',
    'Content-Type': 'application/json'
  };

  Future<APIResponse<List<NotesModelsForListing>>> getNotesList() async {
    return await http
        .get(Uri.parse('$api/notes'), headers: header)
        .then((response) {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<NotesModelsForListing> notes = [];
        for (var item in jsonData) {
          // NotesModelsForListing.fromJson(item);
          notes.add(
            NotesModelsForListing.fromJson(item),
          );
        }
        return APIResponse<List<NotesModelsForListing>>(
            data: notes, error: false);
      }
      return APIResponse<List<NotesModelsForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError(
      (_) => APIResponse<List<NotesModelsForListing>>(
          error: true, errorMessage: 'An errrror occured'),
    );
  }

  Future<APIResponse<NoteDetails>> getNoteDetails(String noteID) {
    return http
        .get(Uri.parse('$api/notes/$noteID'), headers: header)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<NoteDetails>(data: NoteDetails.fromJson(jsonData));
      }
      return APIResponse<NoteDetails>(
          error: true, errorMessage: 'An error occured');
    }).catchError(
      (_) => APIResponse<NoteDetails>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<bool>> createNote(NoteInsert note) {
    return http
        .post(
      Uri.parse('$api/notes'),
      headers: header,
      body: json.encode(
        note.toJson(),
      ),
    )
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteUpdate note) {
    return http
        .put(
      Uri.parse('$api/notes/$noteID'),
      headers: header,
      body: json.encode(
        note.toJson(),
      ),
    )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http
        .delete(Uri.parse('$api/notes/$noteID'), headers: header)
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }
}
