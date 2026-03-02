enum PaymentStatus { paid, pending, overdue }

class InvoiceModel {
  final String id;
  final String month;
  final String year;
  final double amount;
  final String date;
  final PaymentStatus status;

  const InvoiceModel({
    required this.id,
    required this.month,
    required this.year,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class PaymentHistoryModel {
  final String label;
  final String paidBy;
  final String date;
  final double amount;

  const PaymentHistoryModel({
    required this.label,
    required this.paidBy,
    required this.date,
    required this.amount,
  });
}

class BillingModel {
  final double planAmount;
  final String planDescription;
  final String billingCycle;
  final String accountStatus;
  final String nextDue;
  final double currentBalance;
  final List<InvoiceModel> invoices;
  final List<PaymentHistoryModel> paymentHistory;

  const BillingModel({
    required this.planAmount,
    required this.planDescription,
    required this.billingCycle,
    required this.accountStatus,
    required this.nextDue,
    required this.currentBalance,
    required this.invoices,
    required this.paymentHistory,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final sampleBilling = BillingModel(
  planAmount: 2500,
  planDescription: '2x per week',
  billingCycle: 'Monthly Billing',
  accountStatus: 'Active',
  nextDue: 'Sept 30',
  currentBalance: 0,
  invoices: const [
    InvoiceModel(
      id: 'INV-001',
      month: 'SEP',
      year: '2024',
      amount: 2500,
      date: 'September 1, 2024',
      status: PaymentStatus.paid,
    ),
    InvoiceModel(
      id: 'INV-002',
      month: 'AUG',
      year: '2024',
      amount: 2500,
      date: 'August 1, 2024',
      status: PaymentStatus.paid,
    ),
    InvoiceModel(
      id: 'INV-003',
      month: 'JUL',
      year: '2024',
      amount: 2500,
      date: 'July 1, 2024',
      status: PaymentStatus.paid,
    ),
  ],
  paymentHistory: const [
    PaymentHistoryModel(
      label: 'September Payment',
      paidBy: 'Parent Account',
      date: 'Sept 1, 2024',
      amount: 2500,
    ),
    PaymentHistoryModel(
      label: 'August Payment',
      paidBy: 'Parent Account',
      date: 'Aug 1, 2024',
      amount: 2500,
    ),
    PaymentHistoryModel(
      label: 'July Payment',
      paidBy: 'Parent Account',
      date: 'Jul 1, 2024',
      amount: 2500,
    ),
  ],
);
