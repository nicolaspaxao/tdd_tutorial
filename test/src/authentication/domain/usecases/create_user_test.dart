import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repos/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepo repo;
  late CreateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = CreateUser(repo: repo);
  });

  const tParams = CreateUserParams.empty();

  test(
    'should call the [AuthRepo.createUser] successfuly',
    () async {
      //Arrenge
      when(() => repo.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => const Right(null));

      //Act
      final result = await usecase(tParams);

      //Assert
      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => repo.createUser(
          createdAt: tParams.createdAt,
          name: tParams.name,
          avatar: tParams.avatar)).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
