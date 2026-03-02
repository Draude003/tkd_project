class ChildInfo {
  final String name;
  final String beltLevel;
  final String status;
  final String nextClass;
  final String balance;
  final String avatarAsset;

  const ChildInfo({
    required this.name,
    required this.beltLevel,
    required this.status,
    required this.nextClass,
    required this.balance,
    required this.avatarAsset,
  });
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
}

final sampleParent = ParentUser(
  name: 'Maria',
  children: [
    ChildInfo(
      name: 'Carlo dela Cruz',
      beltLevel: 'Green Belt',
      status: 'Active',
      nextClass: 'Tue 5PM',
      balance: '₱0',
      avatarAsset: 'assets/icons/profile.png',
    ),
    ChildInfo(
      name: 'Ana dela Cruz',
      beltLevel: 'Green Belt',
      status: 'Active',
      nextClass: 'Tue 5PM',
      balance: '₱800',
      avatarAsset: 'assets/icons/profile.png',
    ),
  ],
  alerts: [
    'Belt exam scheduled for September 20',
    'Payment reminder for Ana dela Cruz - due in 3 days',
    'Competition registration opens next week',
  ],
);
