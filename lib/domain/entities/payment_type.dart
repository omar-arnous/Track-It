enum PaymentType { cash, bankTransfer, creditCard, mobilePayment }

String mapPaymentTypeToString(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return 'Cash';
    case PaymentType.bankTransfer:
      return 'Bank Transfer';
    case PaymentType.creditCard:
      return 'Credit Card';
    case PaymentType.mobilePayment:
      return 'Mobile Payment';
    default:
      return '';
  }
}
