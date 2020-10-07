import 'package:dartz/dartz.dart';
import 'package:reddit_reader/core/errors/failure.dart';

class InputConverter {
  Either<Failure, String> checkStringLength(String str) {
    if (str.length < 20) {
      return Right(str);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
