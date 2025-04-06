class NetworkError implements Exception {}

class ValidationError implements Exception {}

class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is NetworkError) {
      return 'Network error occurred';
    } else if (error is ValidationError) {
      return 'Validation error occurred';
    }
    return 'An unexpected error occurred';
  }
}
