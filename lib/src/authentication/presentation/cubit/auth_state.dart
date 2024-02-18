part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class CreatingUser extends AuthState {
  const CreatingUser();
}

final class GettingUsers extends AuthState {
  const GettingUsers();
}

final class UserCreated extends AuthState {
  const UserCreated();
}

final class UsersLoaded extends AuthState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => users.map((e) => e.id).toList();
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
