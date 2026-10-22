class Receipt {

  final String receiptId;
  final String merchant;
  final String date;
  final String amount;
  final List<dynamic> items;


  Receipt({
    required this.receiptId,
    required this.merchant,
    required this.date,
    required this.amount,
    required this.items,
  });


  factory Receipt.fromJson(Map<String, dynamic> json) {

    return Receipt(
      receiptId: json['receipt_id'] ?? '',
      merchant: json['merchant'] ?? 'Not found',
      date: json['date'] ?? 'Not found',
      amount: json['amount'] ?? 'Not found',
      items: json['items'] ?? [],
    );
  }
}