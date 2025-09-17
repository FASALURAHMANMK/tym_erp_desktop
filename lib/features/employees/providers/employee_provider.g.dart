// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeRepositoryHash() =>
    r'8e23d6c30de8dadda59e1f27afdbc6355ab390a9';

/// See also [employeeRepository].
@ProviderFor(employeeRepository)
final employeeRepositoryProvider =
    AutoDisposeProvider<EmployeeRepository>.internal(
      employeeRepository,
      name: r'employeeRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeRepositoryRef = AutoDisposeProviderRef<EmployeeRepository>;
String _$employeeRepositoryAsyncHash() =>
    r'894eeab50365667ecffe544315f454a569fc065d';

/// See also [employeeRepositoryAsync].
@ProviderFor(employeeRepositoryAsync)
final employeeRepositoryAsyncProvider =
    AutoDisposeFutureProvider<EmployeeRepository>.internal(
      employeeRepositoryAsync,
      name: r'employeeRepositoryAsyncProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeRepositoryAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeRepositoryAsyncRef =
    AutoDisposeFutureProviderRef<EmployeeRepository>;
String _$employeeServiceHash() => r'2a2bd2c8ad1c04b3b2e1922b14e34fabab8dbfe4';

/// See also [employeeService].
@ProviderFor(employeeService)
final employeeServiceProvider =
    AutoDisposeFutureProvider<EmployeeService>.internal(
      employeeService,
      name: r'employeeServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeServiceRef = AutoDisposeFutureProviderRef<EmployeeService>;
String _$filteredEmployeesHash() => r'e15a57eacc0b3b76be5492b5c579831d18aad7cd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredEmployees].
@ProviderFor(filteredEmployees)
const filteredEmployeesProvider = FilteredEmployeesFamily();

/// See also [filteredEmployees].
class FilteredEmployeesFamily extends Family<List<Employee>> {
  /// See also [filteredEmployees].
  const FilteredEmployeesFamily();

  /// See also [filteredEmployees].
  FilteredEmployeesProvider call({
    String? searchQuery,
    EmployeeRole? role,
    EmploymentStatus? status,
  }) {
    return FilteredEmployeesProvider(
      searchQuery: searchQuery,
      role: role,
      status: status,
    );
  }

  @override
  FilteredEmployeesProvider getProviderOverride(
    covariant FilteredEmployeesProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
      role: provider.role,
      status: provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredEmployeesProvider';
}

/// See also [filteredEmployees].
class FilteredEmployeesProvider extends AutoDisposeProvider<List<Employee>> {
  /// See also [filteredEmployees].
  FilteredEmployeesProvider({
    String? searchQuery,
    EmployeeRole? role,
    EmploymentStatus? status,
  }) : this._internal(
         (ref) => filteredEmployees(
           ref as FilteredEmployeesRef,
           searchQuery: searchQuery,
           role: role,
           status: status,
         ),
         from: filteredEmployeesProvider,
         name: r'filteredEmployeesProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$filteredEmployeesHash,
         dependencies: FilteredEmployeesFamily._dependencies,
         allTransitiveDependencies:
             FilteredEmployeesFamily._allTransitiveDependencies,
         searchQuery: searchQuery,
         role: role,
         status: status,
       );

  FilteredEmployeesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
    required this.role,
    required this.status,
  }) : super.internal();

  final String? searchQuery;
  final EmployeeRole? role;
  final EmploymentStatus? status;

  @override
  Override overrideWith(
    List<Employee> Function(FilteredEmployeesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredEmployeesProvider._internal(
        (ref) => create(ref as FilteredEmployeesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
        role: role,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Employee>> createElement() {
    return _FilteredEmployeesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredEmployeesProvider &&
        other.searchQuery == searchQuery &&
        other.role == role &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredEmployeesRef on AutoDisposeProviderRef<List<Employee>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;

  /// The parameter `role` of this provider.
  EmployeeRole? get role;

  /// The parameter `status` of this provider.
  EmploymentStatus? get status;
}

class _FilteredEmployeesProviderElement
    extends AutoDisposeProviderElement<List<Employee>>
    with FilteredEmployeesRef {
  _FilteredEmployeesProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as FilteredEmployeesProvider).searchQuery;
  @override
  EmployeeRole? get role => (origin as FilteredEmployeesProvider).role;
  @override
  EmploymentStatus? get status => (origin as FilteredEmployeesProvider).status;
}

String _$roleTemplatesHash() => r'eb7ecc14d6ed357056d949eb9703fa6bd11df7e0';

/// See also [roleTemplates].
@ProviderFor(roleTemplates)
final roleTemplatesProvider =
    AutoDisposeFutureProvider<List<RoleTemplate>>.internal(
      roleTemplates,
      name: r'roleTemplatesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$roleTemplatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoleTemplatesRef = AutoDisposeFutureProviderRef<List<RoleTemplate>>;
String _$employeeStatsHash() => r'584374ec6e0b7c6626e363cb52c7e8fa4d32f320';

/// See also [employeeStats].
@ProviderFor(employeeStats)
final employeeStatsProvider =
    AutoDisposeProvider<Map<String, dynamic>>.internal(
      employeeStats,
      name: r'employeeStatsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeStatsRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$currentEmployeeHash() => r'b5f076df424283a048c40e7c9b4199f699074098';

/// See also [currentEmployee].
@ProviderFor(currentEmployee)
final currentEmployeeProvider = AutoDisposeProvider<Employee?>.internal(
  currentEmployee,
  name: r'currentEmployeeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentEmployeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentEmployeeRef = AutoDisposeProviderRef<Employee?>;
String _$hasPermissionHash() => r'4532a3ad1040fa63bed74d1246d3ed8cd3578136';

/// See also [hasPermission].
@ProviderFor(hasPermission)
const hasPermissionProvider = HasPermissionFamily();

/// See also [hasPermission].
class HasPermissionFamily extends Family<AsyncValue<bool>> {
  /// See also [hasPermission].
  const HasPermissionFamily();

  /// See also [hasPermission].
  HasPermissionProvider call(String permission) {
    return HasPermissionProvider(permission);
  }

  @override
  HasPermissionProvider getProviderOverride(
    covariant HasPermissionProvider provider,
  ) {
    return call(provider.permission);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hasPermissionProvider';
}

/// See also [hasPermission].
class HasPermissionProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [hasPermission].
  HasPermissionProvider(String permission)
    : this._internal(
        (ref) => hasPermission(ref as HasPermissionRef, permission),
        from: hasPermissionProvider,
        name: r'hasPermissionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hasPermissionHash,
        dependencies: HasPermissionFamily._dependencies,
        allTransitiveDependencies:
            HasPermissionFamily._allTransitiveDependencies,
        permission: permission,
      );

  HasPermissionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permission,
  }) : super.internal();

  final String permission;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasPermissionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasPermissionProvider._internal(
        (ref) => create(ref as HasPermissionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permission: permission,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasPermissionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasPermissionProvider && other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasPermissionRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `permission` of this provider.
  String get permission;
}

class _HasPermissionProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with HasPermissionRef {
  _HasPermissionProviderElement(super.provider);

  @override
  String get permission => (origin as HasPermissionProvider).permission;
}

String _$employeesNotifierHash() => r'89a1d1a4a7702c0a18f46126a7744d4e498016ee';

/// See also [EmployeesNotifier].
@ProviderFor(EmployeesNotifier)
final employeesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  EmployeesNotifier,
  List<Employee>
>.internal(
  EmployeesNotifier.new,
  name: r'employeesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$employeesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeesNotifier = AutoDisposeAsyncNotifier<List<Employee>>;
String _$employeeSessionNotifierHash() =>
    r'c601c85631f24743606d3583c8b47ad48ff437a2';

/// See also [EmployeeSessionNotifier].
@ProviderFor(EmployeeSessionNotifier)
final employeeSessionNotifierProvider = AutoDisposeNotifierProvider<
  EmployeeSessionNotifier,
  EmployeeSession?
>.internal(
  EmployeeSessionNotifier.new,
  name: r'employeeSessionNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$employeeSessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeSessionNotifier = AutoDisposeNotifier<EmployeeSession?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
