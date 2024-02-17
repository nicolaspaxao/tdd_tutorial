import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/auth_remote_data_source.dart';

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
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
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
        ),
      );
      verifyNoMoreInteractions(client);
    });

    test(
      'should thrown [ApiException] when the status code is not 200 or 2001',
      () async {
        when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
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
          ),
        );

        verifyNoMoreInteractions(client);
      },
    );
  });
}
