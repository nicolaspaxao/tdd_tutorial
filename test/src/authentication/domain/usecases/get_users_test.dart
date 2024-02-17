import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepo repo;
  late GetUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = GetUser(repo: repo);
  });

  const tResponse = [User.empty()];
  test('should call [AuthRepo.getUser] and return a [List<User>]', () async {
    when(() => repo.getUsers()).thenAnswer((_) async => const Right(tResponse));

    final result = await usecase();

    expect(result.length(), equals(1));
    expect(result, equals(const Right<dynamic, List<User>>(tResponse)));

    verify(() => repo.getUsers()).called(1);

    verifyNoMoreInteractions(repo);
  });
}
