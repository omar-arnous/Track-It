import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/auth_cache_datasource.dart';
import 'package:trackit/data/datasources/auth_remote_datasource.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthCacheDatasource cacheDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.cacheDatasource,
  });

  @override
  Future<Either<Failure, User>> createUser(
      String email, String name, String password) async {
    try {
      final user = await remoteDatasource.signUp(email, name, password);
      cacheDatasource.cacheUser(user);
      return Right(user);
    } on WeakPasswordAuthException {
      return Left(WeakPasswordAuthFailure());
    } on EmailAlreadyInUseAuthException {
      return Left(EmailAlreadyInUseAuthFailure());
    } on InvalidEmailAuthException {
      return Left(InvalidEmailAuthFailure());
    } on UserNotLoggedInAuthException {
      return Left(UserNotLoggedInAuthFailure());
    } on GenreicAuthException {
      return Left(GenericAuthFailure());
    }
  }

  @override
  Future<Either<Failure, User>> logIn(String email, String password) async {
    try {
      final user = await remoteDatasource.signIn(email, password);
      cacheDatasource.cacheUser(user);
      return Right(user);
    } on UserNotFoundAuthException {
      return Left(UserNotFoundAuthFailure());
    } on WrongPasswordAuthException {
      return Left(WrongPasswordAuthFailure());
    } on GenreicAuthException {
      return Left(GenericAuthFailure());
    }
  }

  @override
  Future<Unit> logOut() async {
    await remoteDatasource.signOut();
    cacheDatasource.clearUser();
    return Future.value(unit);
  }

  @override
  Future<Unit> resetPassword(String email) async {
    return await remoteDatasource.resetPassword(email);
  }
}
