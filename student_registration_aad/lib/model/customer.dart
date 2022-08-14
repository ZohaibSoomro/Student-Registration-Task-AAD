class Customer {
  int customerNumber;
  String? customerFirstName;
  String? customerLastName;
  String? phone;
  String? addressLine1;
  String? city;
  String? state;
  String? postalCode;
  String? salesRepEmployeeNumber;
  String? country;
  String? creditLimit;

  Customer({
    required this.customerNumber,
    this.customerFirstName,
    this.addressLine1,
    this.city,
    this.country,
    this.creditLimit,
    this.customerLastName,
    this.phone,
    this.postalCode,
    this.salesRepEmployeeNumber,
    this.state,
  });

  @override
  String toString() {
    return "Customer{number: $customerNumber}";
  }
}
