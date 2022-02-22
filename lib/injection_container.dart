import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/util/api_basehelper.dart';
import 'notes_container.dart';


final sl = GetIt.instance;
final helper = ApiBaseHelper();
late final SharedPreferences sharedPreferences;
Future<void> init() async {
  sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => helper);
  helper.dioInit();
  await initNotesInjection(sl);
  print(helper.dio.options.baseUrl);
}

