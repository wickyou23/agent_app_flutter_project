import 'package:agent_app/bloc/app/app_cubit.dart';
import 'package:agent_app/bloc/auth/auth_cubit.dart';
import 'package:agent_app/data/middlewares/auth_middleware.dart';
import 'package:agent_app/data/models/user.dart';
import 'package:agent_app/data/repositories/auth_repository.dart';
import 'package:agent_app/services/conectivity_service.dart';
import 'package:agent_app/services/local_storage_service.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.I;

void setupDependencyInjection() {
  di
    //Object here
    ..registerFactory<User>(User.new)

    //Middleware here
    ..registerFactory<AuthMiddleware>(AuthMiddleware.new)

    //Cubit here
    ..registerFactory<AuthCubit>(AuthCubit.new)

    //Singleton here
    ..registerLazySingleton<AppCubit>(AppCubit.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<LocalStoreService>(LocalStoreService.new)

    //Repository here
    ..registerLazySingleton<AuthRepository>(AuthRepository.new);
}
