import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';

class GetUser extends UsecaseWithoutParams<List<User>> {
  final AuthRepo _repo;

  GetUser({required AuthRepo repo}) : _repo = repo;

  @override
  ResultFuture<List<User>> call() async => _repo.getUsers();
}
