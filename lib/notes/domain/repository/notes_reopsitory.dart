import 'package:bawq/core/error/failures.dart';
import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:bawq/notes/domain/usecase/get_notes.dart';
import 'package:dartz/dartz.dart';

abstract class NotesRepository{
  Future<Either<Failure, GetNotesResponse>> getNotes(
      GetNotesParams params);
}