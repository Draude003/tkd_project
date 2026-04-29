enum PaymentStatus { paid, pending, overdue, pendingVerification, partial }

class InvoiceModel {
  final String id;
  final String invoiceNo;
  final String month;
  final String year;
  final double amount;
  final String date;
  final String dueDate;
  final PaymentStatus status;
  final String? paymentProof;

  const InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.month,
    required this.year,
    required this.amount,
    required this.date,
    required this.dueDate,
    required this.status,
    this.paymentProof,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    PaymentStatus status;
    switch (json['status']) {
      case 'paid':
        status = PaymentStatus.paid;
        break;
      case 'overdue':
        status = PaymentStatus.overdue;
        break;
      case 'pending_verification':
        status = PaymentStatus.pendingVerification;
        break;
      case 'partial':
        status = PaymentStatus.partial;
        break;
      default:
        status = PaymentStatus.pending;
    }

    return InvoiceModel(
      id: json['id'].toString(),
      invoiceNo: json['invoice_no'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      amount: double.parse(json['amount'].toString()),
      date: json['date'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: status,
      paymentProof: json['payment_proof'],
    );
  }
}

class PaymentHistoryModel {
  final String id;
  final String label;
  final String paymentMethod;
  final String date;
  final double amount;

  const PaymentHistoryModel({
    required this.id,
    required this.label,
    required this.paymentMethod,
    required this.date,
    required this.amount,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'].toString(),
      label: json['label'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      date: json['date'] ?? '',
      amount: double.parse(json['amount'].toString()),
    );
  }
}

class PlanModel {
  final String name;
  final double amount;
  final String description;
  final String billingCycle;
  final String nextDue;

  const PlanModel({
    required this.name,
    required this.amount,
    required this.description,
    required this.billingCycle,
    required this.nextDue,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      name: json['name'] ?? '',
      amount: double.parse(json['amount'].toString()),
      description: json['description'] ?? '',
      billingCycle: json['billing_cycle'] ?? 'Monthly',
      nextDue: json['next_due'] ?? 'N/A',
    );
  }
}

class PendingInvoiceModel {
  final String id;
  final String invoiceNo;
  final double amount;
  final String dueDate;
  final String status;

  const PendingInvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory PendingInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PendingInvoiceModel(
      id: json['id'].toString(),
      invoiceNo: json['invoice_no'] ?? '',
      amount: double.parse(json['amount'].toString()),
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}

class BillingModel {
  final PlanModel? plan;
  final double balance;
  final List<InvoiceModel> invoices;
  final List<PaymentHistoryModel> paymentHistory;
  final PendingInvoiceModel? pendingInvoice;

  const BillingModel({
    this.plan,
    required this.balance,
    required this.invoices,
    required this.paymentHistory,
    this.pendingInvoice,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      plan: json['plan'] != null
          ? PlanModel.fromJson(Map<String, dynamic>.from(json['plan']))
          : null,
      balance: double.parse(json['balance'].toString()),
      invoices: (json['invoices'] as List)
          .map((i) => InvoiceModel.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
      paymentHistory: (json['payment_history'] as List)
          .map(
            (p) => PaymentHistoryModel.fromJson(Map<String, dynamic>.from(p)),
          )
          .toList(),
      pendingInvoice: json['pending_invoice'] != null
          ? PendingInvoiceModel.fromJson(
              Map<String, dynamic>.from(json['pending_invoice']),
            )
          : null,
    );
  }
}
