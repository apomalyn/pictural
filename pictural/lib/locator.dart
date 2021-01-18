
import 'package:get_it/get_it.dart';
import 'package:pictural/core/managers/user_repository.dart';
import 'package:pictural/core/services/navigation_service.dart';
import 'package:pictural/core/services/pictural_api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PicturalApi());

  // Manager
  locator.registerLazySingleton(() => UserRepository());
}
