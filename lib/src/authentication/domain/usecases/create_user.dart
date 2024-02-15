import 'package:equatable/equatable.dart';

import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  final AuthRepo _repo;

  CreateUser({required AuthRepo repo}) : _repo = repo;

  @override
  ResultFuture call(CreateUserParams params) async => await _repo.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [createdAt, name, avatar];
}
