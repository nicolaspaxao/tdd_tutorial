import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repo/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl

    ///App Logic
    ..registerFactory(() => AuthCubit(createUser: sl(), getUser: sl()))

    //Use Cases
    ..registerLazySingleton(() => CreateUser(repo: sl()))
    ..registerLazySingleton(() => GetUser(repo: sl()))

    //Repositories
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(dataSource: sl()))

    //Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()))

    //External Dependencies
    ..registerLazySingleton(() => http.Client());
}
