class NetworkVerificationState {
  final bool isLoading;
  final String? error;
  final bool isConnected;
  final String? wifiName;

  NetworkVerificationState({
    this.isLoading = false,
    this.error,
    this.isConnected = false,
    this.wifiName,
  });

  NetworkVerificationState copyWith({
    bool? isLoading,
    String? error,
    bool? isConnected,
    String? wifiName,
  }) {
    return NetworkVerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
      wifiName: wifiName ?? this.wifiName,
    );
  }
}
