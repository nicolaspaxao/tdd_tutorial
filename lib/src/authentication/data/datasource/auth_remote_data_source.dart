import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';

import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/users';
const kGetUsersEndpoint = '/user';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSourceImpl({required http.Client client}) : _client = client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //1. check to make sure that it returns the right data when the response
    //code is 200 or the proper response code
    //2. Check to make sure that it "Throwns" a custom exception with right
    //message when status code is the bad one
    final response = await _client.post(
      Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
      body: jsonEncode(
        {'createdAt': createdAt, 'name': name, 'avatar': avatar},
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(
          message: response.body, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    throw UnimplementedError();
  }
}
