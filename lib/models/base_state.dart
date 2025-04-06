abstract class BaseState {
  bool isLoading = false;
  String? error;

  void setLoading(bool loading) {
    isLoading = loading;
  }

  void setError(String? errorMessage) {
    error = errorMessage;
  }
}
