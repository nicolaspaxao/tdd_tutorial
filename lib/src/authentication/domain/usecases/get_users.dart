import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';

class GetUser {
  final AuthRepo _repo;

  GetUser({required AuthRepo repo}) : _repo = repo;

  ResultFuture<List<User>> getUsers() async => _repo.getUsers();
}
