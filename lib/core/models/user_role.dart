/// Enum untuk role user di sistem
/// Mapping: database value (string) -> enum
enum UserRole {
  user('user', 'Pengguna'),
  admin('admin', 'Admin'),
  helpdesk('helpdesk', 'Helpdesk');

  final String value;
  final String label;
  const UserRole(this.value, this.label);

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }

  /// Default route saat login
  String get defaultRoute {
    switch (this) {
      case UserRole.admin:
        return '/admin';
      case UserRole.helpdesk:
        return '/helpdesk';
      case UserRole.user:
        return '/home';
    }
  }
}
