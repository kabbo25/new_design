class LocationVerificationState {
  final bool isLoading;
  final String? error;
  final bool isLocationFound;
  final String? address;

  LocationVerificationState({
    this.isLoading = false,
    this.error,
    this.isLocationFound = false,
    this.address,
  });

  LocationVerificationState copyWith({
    bool? isLoading,
    String? error,
    bool? isLocationFound,
    String? address,
  }) {
    return LocationVerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isLocationFound: isLocationFound ?? this.isLocationFound,
      address: address ?? this.address,
    );
  }
}
