import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failures.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';

class MockGetUsers extends Mock implements GetUser {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUser getUsers;
  late CreateUser createUser;
  late AuthCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthCubit(createUser: createUser, getUser: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be [AuthInitial]', () async {
    expect(cubit.state, const AuthInitial());
  });

  group('createUser', () {
    blocTest<AuthCubit, AuthState>(
      'shold emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const <AuthState>[CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [CreatingUser, AuthError] when unsuccesful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Left(tApiFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => <AuthState>[
        const CreatingUser(),
        AuthError(tApiFailure.errorMessage)
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest(
      'should emit [GettingUsers, UsersLoaded] when successfull',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthState>[const GettingUsers(), const UsersLoaded([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest(
      'should emit [GettingUsers, AuthError] when unsuccessfull',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthState>[
        const GettingUsers(),
        AuthError(tApiFailure.errorMessage)
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
}
