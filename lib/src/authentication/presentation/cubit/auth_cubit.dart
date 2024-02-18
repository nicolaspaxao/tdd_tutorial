import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required CreateUser createUser,
    required GetUser getUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        super(const AuthInitial());

  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));

    result.fold(
      (l) => emit(AuthError(l.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUsers() async {
    emit(const GettingUsers());

    final result = await _getUser();

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
