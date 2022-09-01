class PendingOrderModel {
  int orderNo;
  String orderDate;
  String customerNo;
  int totalItem;
  String totalAmount;

  PendingOrderModel(
      {this.orderNo,
      this.orderDate,
      this.customerNo,
      this.totalItem,
      this.totalAmount});

  PendingOrderModel.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    orderDate = json['order_date'];
    customerNo = json['customer_no'];
    totalItem = json['total_item'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['order_no'] = orderNo;
    data['order_date'] = orderDate;
    data['customer_no'] = customerNo;
    data['total_item'] = totalItem;
    data['total_amount'] = totalAmount;
    return data;
  }
}
