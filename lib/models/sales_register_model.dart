class RegisterSalesModel {
  String customerCode;
  String date;
  String billNo;
  int totalItem;
  double totalAmount;

  RegisterSalesModel(
      {this.customerCode,
      this.date,
      this.billNo,
      this.totalItem,
      this.totalAmount});

  RegisterSalesModel.fromJson(Map<String, dynamic> json) {
    customerCode = json['customer_code'];
    date = json['date'];
    billNo = json['bill_no'];
    totalItem = json['total_item'];
    totalAmount = double.parse(json['total_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['customer_code'] = customerCode;
    data['date'] = date;
    data['bill_no'] = billNo;
    data['total_item'] = totalItem;
    data['total_amount'] = totalAmount;
    return data;
  }
}
