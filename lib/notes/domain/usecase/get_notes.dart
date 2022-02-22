import 'package:bawq/core/error/failures.dart';
import 'package:bawq/core/usecases/usecases.dart';
import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:bawq/notes/domain/repository/notes_reopsitory.dart';
import 'package:dartz/dartz.dart';

class GetNotes extends UseCase<GetNotesResponse, GetNotesParams> {
  final NotesRepository repository;

  GetNotes({required this.repository});

  @override
  Future<Either<Failure, GetNotesResponse>> call(GetNotesParams params) async {
    return await repository.getNotes(params);
  }
}

class GetNotesParams {
  String? content;

  GetNotesParams({
    this.content,
  });
}
