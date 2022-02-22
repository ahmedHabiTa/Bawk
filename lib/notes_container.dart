import 'package:bawq/notes/data/datasources/remote_data_source.dart';
import 'package:bawq/notes/data/repository/notes-repository_impl.dart';
import 'package:bawq/notes/domain/repository/notes_reopsitory.dart';
import 'package:get_it/get_it.dart';

import 'notes/domain/usecase/get_notes.dart';
import 'notes/presentation/provider/notes_provider.dart';

Future<void> initNotesInjection(GetIt sl) async {
  //* provider
  sl.registerFactory(
    () => NotesProvider(
      getNotes: sl(),
      helper: sl(),

    ),
  );

  //* Use cases
  sl.registerLazySingleton(() => GetNotes(repository: sl()));


  //* Repository
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remote: sl()),
  );

  //* Data sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(
      helper: sl(),
    ),
  );
  //
}

