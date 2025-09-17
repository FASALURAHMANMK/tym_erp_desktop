import 'business_model.dart';

class BusinessState {
  final List<BusinessModel> userBusinesses;
  final BusinessModel? selectedBusiness;
  final bool isLoading;
  final String? error;
  final bool hasCheckedBusinesses;
  final bool isOfflineMode;

  const BusinessState({
    this.userBusinesses = const [],
    this.selectedBusiness,
    this.isLoading = false,
    this.error,
    this.hasCheckedBusinesses = false,
    this.isOfflineMode = false,
  });

  BusinessState copyWith({
    List<BusinessModel>? userBusinesses,
    BusinessModel? selectedBusiness,
    bool? isLoading,
    String? error,
    bool? hasCheckedBusinesses,
    bool? isOfflineMode,
  }) {
    return BusinessState(
      userBusinesses: userBusinesses ?? this.userBusinesses,
      selectedBusiness: selectedBusiness ?? this.selectedBusiness,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasCheckedBusinesses: hasCheckedBusinesses ?? this.hasCheckedBusinesses,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }

  bool get hasBusinesses => userBusinesses.isNotEmpty;
  bool get hasMultipleBusinesses => userBusinesses.length > 1;
  bool get hasSelectedBusiness => selectedBusiness != null;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusinessState &&
        other.userBusinesses == userBusinesses &&
        other.selectedBusiness == selectedBusiness &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.hasCheckedBusinesses == hasCheckedBusinesses &&
        other.isOfflineMode == isOfflineMode;
  }

  @override
  int get hashCode {
    return Object.hash(
      userBusinesses,
      selectedBusiness,
      isLoading,
      error,
      hasCheckedBusinesses,
      isOfflineMode,
    );
  }

  @override
  String toString() {
    return 'BusinessState(businesses: ${userBusinesses.length}, selected: ${selectedBusiness?.name}, loading: $isLoading, hasChecked: $hasCheckedBusinesses, offline: $isOfflineMode)';
  }
}