class NetworkVerificationState {
  final bool isLoading;
  final String? error;

  NetworkVerificationState({
    this.isLoading = false,
    this.error,
  });

  NetworkVerificationState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return NetworkVerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
