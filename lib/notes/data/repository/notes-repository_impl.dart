import 'package:bawq/core/error/exceptions.dart';
import 'package:bawq/core/error/failures.dart';
import 'package:bawq/notes/data/datasources/remote_data_source.dart';
import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:bawq/notes/domain/repository/notes_reopsitory.dart';
import 'package:bawq/notes/domain/usecase/get_notes.dart';
import 'package:dartz/dartz.dart';

class NotesRepositoryImpl implements NotesRepository {

  final RemoteDataSource remote;

  NotesRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, GetNotesResponse>> getNotes(
      GetNotesParams params) async {
    try {
      GetNotesResponse getNotesResponse =
      await remote.getNotes(params);
      return Right(getNotesResponse);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

