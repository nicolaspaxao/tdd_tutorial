import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';

typedef ResultFuture<Sucess> = Future<Either<Failure, Sucess>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;
