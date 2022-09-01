class RegisterSalesDetailsModel {
  int id;
  String customerCode;
  String billNo;
  String date;
  String customerName;
  String code;
  String modelDescription;
  String qty;
  String rate;
  String amount;
  String scheme;
  String gross;
  String docketNo;
  String sentThrough;
  String hsnCode;
  String igst;
  String cgst;
  String sgst;
  String uniqueNo;
  Null deletedAt;
  String updatedAt;
  String createdAt;

  RegisterSalesDetailsModel(
      {this.id,
      this.customerCode,
      this.billNo,
      this.date,
      this.customerName,
      this.code,
      this.modelDescription,
      this.qty,
      this.rate,
      this.amount,
      this.scheme,
      this.gross,
      this.docketNo,
      this.sentThrough,
      this.hsnCode,
      this.igst,
      this.cgst,
      this.sgst,
      this.uniqueNo,
      this.deletedAt,
      this.updatedAt,
      this.createdAt});

  RegisterSalesDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customer_code'];
    billNo = json['bill_no'];
    date = json['date'];
    customerName = json['customer_name'];
    code = json['code'];
    modelDescription = json['model_description'];
    qty = json['qty'];
    rate = json['rate'];
    amount = json['amount'];
    scheme = json['scheme'];
    gross = json['gross'];
    docketNo = json['docket_no'];
    sentThrough = json['sent_through'];
    hsnCode = json['hsn_code'];
    igst = json['igst'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    uniqueNo = json['unique_no'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_code'] = customerCode;
    data['bill_no'] = billNo;
    data['date'] = date;
    data['customer_name'] = customerName;
    data['code'] = code;
    data['model_description'] = modelDescription;
    data['qty'] = qty;
    data['rate'] = rate;
    data['amount'] = amount;
    data['scheme'] = scheme;
    data['gross'] = gross;
    data['docket_no'] = docketNo;
    data['sent_through'] = sentThrough;
    data['hsn_code'] = hsnCode;
    data['igst'] = igst;
    data['cgst'] = cgst;
    data['sgst'] = sgst;
    data['unique_no'] = uniqueNo;
    data['deleted_at'] = deletedAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
