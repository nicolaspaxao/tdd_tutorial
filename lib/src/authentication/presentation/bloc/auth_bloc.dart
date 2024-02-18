import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CreateUser createUser,
    required GetUser getUser,
  })  : _createUser = createUser,
        _getUser = getUser,
        super(const AuthInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUser _createUser;
  final GetUser _getUser;

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));

    result.fold(
      (l) => emit(AuthError(l.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const GettingUsers());

    final result = await _getUser();

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
