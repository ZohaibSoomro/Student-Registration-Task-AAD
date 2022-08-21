class CardDetails {
  String? cardHolderName;
  String? cardNumber;
  String? expiryMonth;
  String? expiryYear;
  String? cvcNumber;

  CardDetails({
    this.cardHolderName,
    this.cardNumber,
    this.cvcNumber,
    this.expiryMonth,
    this.expiryYear,
  });

  bool isNotEmpty() {
    return cardHolderName != null &&
        cardNumber != null &&
        cvcNumber != null &&
        expiryMonth != null &&
        expiryYear != null;
  }
}
