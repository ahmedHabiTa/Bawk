import 'package:bawq/core/error/exceptions.dart';
import 'package:bawq/core/util/api_basehelper.dart';
import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:bawq/notes/domain/usecase/get_notes.dart';

abstract class RemoteDataSource{
  Future<GetNotesResponse> getNotes(
      GetNotesParams params);
}
class RemoteDataSourceImpl implements RemoteDataSource {

  final ApiBaseHelper helper;

  RemoteDataSourceImpl({required this.helper});

  @override
  Future<GetNotesResponse> getNotes(GetNotesParams params) async {
    try {
      final response =
      await helper.get(url: getNotesApi);
      GetNotesResponse getNotesResponse =
      GetNotesResponse.fromMap(response);
      return getNotesResponse;
    } catch (e) {
      throw ServerException();
    }
  }
}

