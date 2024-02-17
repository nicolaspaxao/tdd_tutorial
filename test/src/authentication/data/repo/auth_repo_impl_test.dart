import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repo/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource dataSource;
  late AuthRepoImpl repo;

  setUp(() {
    dataSource = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(dataSource: dataSource);
  });

  const tCreatedAt = 'tCreatedAt';
  const tName = 'tName';
  const tAvatar = 'tAvatar';

  const tException = ApiException(
    message: 'Unkown error occured',
    statusCode: 500,
  );

  group('createUser', () {
    test(
      'should call the [RemoteDatasource.createUser] and complete successfully when the call to the remote is successful',
      () async {
        when(
          () => dataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')),
        ).thenAnswer((_) async => Future.value());
        final result = await repo.createUser(
            createdAt: tCreatedAt, name: tName, avatar: tAvatar);
        expect(result, equals(const Right(null)));
        verify(() => dataSource.createUser(
            createdAt: tCreatedAt, name: tName, avatar: tAvatar)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'should return a  [ServerFailure] when the call to the remote source is unsuccessful',
      () async {
        when(
          () => dataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);
        final call = await repo.createUser(
            createdAt: tCreatedAt, name: tName, avatar: tAvatar);
        expect(
          call,
          equals(Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          )),
        );
        verify(() => dataSource.createUser(
            createdAt: tCreatedAt, name: tName, avatar: tAvatar)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });

  group('getUser', () {
    test(
      'should call the [RemoteDatasource.getUsers] and return a [List<User>] when call to remote source is succesful',
      () async {
        when(() => dataSource.getUsers())
            .thenAnswer((_) async => [const UserModel.empty()]);
        final result = await repo.getUsers();
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(() => dataSource.getUsers()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'should return a  [ServerFailure] when the call to the remote source is unsuccessful',
      () async {
        when(() => dataSource.getUsers()).thenThrow(tException);
        final result = await repo.getUsers();
        expect(result, equals(Left(ApiFailure.fromException(tException))));
        verify(() => dataSource.getUsers()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
