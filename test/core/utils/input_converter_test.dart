import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_reader/core/utils/input_converter.dart';

void main() {
  InputConverter inputConvertor;

  setUp(() {
    inputConvertor = InputConverter();
  });

  test('should return string when the string is less 20 chars', () {
    final str = 'Flutter';
    final result = inputConvertor.checkStringLength(str);
    expect(result, Right(str));
  });

  test('should return InvalidInputFailure when the string is more or equals 20 chars', () {
    final str = 'FlutterFlutterFlutterFlutter';
    final result = inputConvertor.checkStringLength(str);
    expect(result, Left(InvalidInputFailure()));
  });
}
