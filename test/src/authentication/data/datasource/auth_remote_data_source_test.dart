import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    client = MockClient();
    dataSourceImpl = AuthRemoteDataSourceImpl(client: client);
    registerFallbackValue(Uri());
  });

  const tCreatedAt = 'tCreatedAt';
  const tName = 'tName';
  const tAvatar = 'tAvatar';
  group('createUser', () {
    test('should complete successfully when the status code is OK', () async {
      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: {"Content-Type": 'application/json'},
          )).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      final call = dataSourceImpl.createUser;

      expect(
        call(createdAt: tCreatedAt, name: tName, avatar: tAvatar),
        completes,
      );

      verify(
        () => client.post(
          Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: jsonEncode(
            {'createdAt': tCreatedAt, 'name': tName, 'avatar': tAvatar},
          ),
          headers: {"Content-Type": 'application/json'},
        ),
      );
      verifyNoMoreInteractions(client);
    });

    test(
      'should thrown [ApiException] when the status code is not 200 or 201',
      () async {
        when(() => client.post(
              any(),
              body: any(named: 'body'),
              headers: {"Content-Type": 'application/json'},
            )).thenAnswer(
          (_) async => http.Response('Invalid email address', 400),
        );

        final call = dataSourceImpl.createUser;

        expect(
          () => call(createdAt: tCreatedAt, name: tName, avatar: tAvatar),
          throwsA(
            const ApiException(
              message: 'Invalid email address',
              statusCode: 400,
            ),
          ),
        );

        verify(
          () => client.post(
            Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
            body: jsonEncode(
              {'createdAt': tCreatedAt, 'name': tName, 'avatar': tAvatar},
            ),
            headers: {"Content-Type": 'application/json'},
          ),
        );

        verifyNoMoreInteractions(client);
      },
    );
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test(
      'should return [List<User>] when the status code is 200',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
        );
        final result = await dataSourceImpl.getUsers();

        expect(result, equals(tUsers));

        verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint')))
            .called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should thrown [ApiException] when the status code is not 200',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(
            'Server down, try again in 500 years. Thank you',
            500,
          ),
        );
        final methodCall = dataSourceImpl.getUsers;

        expect(
          () => methodCall(),
          throwsA(
            const ApiException(
              message: 'Server down, try again in 500 years. Thank you',
              statusCode: 500,
            ),
          ),
        );

        verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint')))
            .called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
