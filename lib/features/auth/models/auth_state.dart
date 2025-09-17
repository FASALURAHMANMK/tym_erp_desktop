import 'user_model.dart';

class AppAuthState {
  final UserModel? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AppAuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  factory AppAuthState.fromJson(Map<String, dynamic> json) {
    return AppAuthState(
      user: json['user'] != null 
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      isLoading: json['isLoading'] as bool? ?? false,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'isLoading': isLoading,
      'isAuthenticated': isAuthenticated,
      'error': error,
    };
  }

  AppAuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AppAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAuthState &&
        other.user == user &&
        other.isLoading == isLoading &&
        other.isAuthenticated == isAuthenticated &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(user, isLoading, isAuthenticated, error);
  }

  @override
  String toString() {
    return 'AppAuthState(user: $user, isLoading: $isLoading, isAuthenticated: $isAuthenticated, error: $error)';
  }
}