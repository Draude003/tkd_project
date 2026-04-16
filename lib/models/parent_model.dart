class ChildInfo {
  final int id;
  final String name;
  final String beltLevel;
  final String status;
  final String nextClass;
  final String balance;

  const ChildInfo({
    required this.id,
    required this.name,
    required this.beltLevel,
    required this.status,
    required this.nextClass,
    required this.balance,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    return ChildInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      beltLevel: json['belt'] ?? 'No Belt',
      status: json['status'] ?? 'active',
      nextClass: json['next_class'] ?? 'No class scheduled',
      balance: json['balance'] ?? '₱0',
    );
  }
}

class ParentUser {
  final String name;
  final List<ChildInfo> children;
  final List<String> alerts;

  const ParentUser({
    required this.name,
    required this.children,
    required this.alerts,
  });

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
      name: json['name'] ?? '',
      children: (json['children'] as List<dynamic>? ?? [])
          .map((c) => ChildInfo.fromJson(c))
          .toList(),
      alerts: List<String>.from(json['alerts'] ?? []),
    );
  }
}