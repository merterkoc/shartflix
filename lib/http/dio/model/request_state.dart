enum RequestState {
  /// Request is not initialized
  notInitialized,

  /// Request is initialized
  initialized,

  /// Request is loading
  loading,

  /// Request is success
  success,

  /// Request is error
  error;

  bool get isNotInitialized =>
      this == RequestState.notInitialized || this == RequestState.initialized;

  bool get isLoading => this == RequestState.loading;

  bool get isSuccess => this == RequestState.success;

  bool get isError => this == RequestState.error;
}
