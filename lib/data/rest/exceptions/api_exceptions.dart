import 'package:test_bloc/data/rest/models/error_model.dart';

class RestApiException implements Exception {

  final ErrorModel errorModel;

  RestApiException(this.errorModel);

  @override
  String toString() {
    return 'RestApiException{errorModel: $errorModel}';
  }
}