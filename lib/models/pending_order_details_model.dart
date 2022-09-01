class PendingOrderDetailsModel {
  int id;
  int orderNo;
  String orderDate;
  String customerNo;
  String customerName;
  String material;
  String materialDesc;
  int orderQty;
  int deliveredQty;
  int pendingQty;
  String status;
  String plant;
  String pricelist;
  String netPrice;
  String netValue;
  String uniqueId;
  String deletedAt;
  String createdAt;
  String updatedAt;

  PendingOrderDetailsModel(
      {this.id,
      this.orderNo,
      this.orderDate,
      this.customerNo,
      this.customerName,
      this.material,
      this.materialDesc,
      this.orderQty,
      this.deliveredQty,
      this.pendingQty,
      this.status,
      this.plant,
      this.pricelist,
      this.netPrice,
      this.netValue,
      this.uniqueId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  PendingOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    orderDate = json['order_date'];
    customerNo = json['customer_no'];
    customerName = json['customer_name'];
    material = json['material'];
    materialDesc = json['material_desc'];
    orderQty = json['order_qty'];
    deliveredQty = json['delivered_qty'];
    pendingQty = json['pending_qty'];
    status = json['status'];
    plant = json['plant'];
    pricelist = json['pricelist'];
    netPrice = json['net_price'];
    netValue = json['net_value'];
    uniqueId = json['unique_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['order_date'] = orderDate;
    data['customer_no'] = customerNo;
    data['customer_name'] = customerName;
    data['material'] = material;
    data['material_desc'] = materialDesc;
    data['order_qty'] = orderQty;
    data['delivered_qty'] = deliveredQty;
    data['pending_qty'] = pendingQty;
    data['status'] = status;
    data['plant'] = plant;
    data['pricelist'] = pricelist;
    data['net_price'] = netPrice;
    data['net_value'] = netValue;
    data['unique_id'] = uniqueId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
