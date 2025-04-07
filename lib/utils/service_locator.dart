import 'package:get_it/get_it.dart';
import 'package:guardian_angel/utils/http_services.dart';

GetIt locator = new GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => HttpService());
}
