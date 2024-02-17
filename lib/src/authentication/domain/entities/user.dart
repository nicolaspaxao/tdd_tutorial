// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  const User.empty()
      : this(
          id: '1',
          createdAt: '_empty',
          name: '_empty',
          avatar: '_empty',
        );

  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [id, createdAt, name, avatar];
}
