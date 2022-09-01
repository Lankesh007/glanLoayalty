class InvoiceModel {
  int id;
  String custCode;
  String assignment;
  String documentNo;
  String type;
  String docDate;
  String s;
  String dd;
  String amtInLocCur;
  String lcurr;
  String clrngDoc;
  String text;
  String address;
  String deletedAt;
  String updatedAt;
  String createdAt;

  InvoiceModel(
      {this.id,
      this.custCode,
      this.assignment,
      this.documentNo,
      this.type,
      this.docDate,
      this.s,
      this.dd,
      this.amtInLocCur,
      this.lcurr,
      this.clrngDoc,
      this.text,
      this.address,
      this.deletedAt,
      this.updatedAt,
      this.createdAt});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    custCode = json['cust_code'];
    assignment = json['assignment'];
    documentNo = json['document_no'];
    type = json['type'];
    docDate = json['doc_date'];
    s = json['s'];
    dd = json['dd'];
    amtInLocCur = json['amt_in_loc_cur'];
    lcurr = json['lcurr'];
    clrngDoc = json['clrng_doc'];
    text = json['text'];
    address = json['address'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cust_code'] = custCode;
    data['assignment'] = assignment;
    data['document_no'] = documentNo;
    data['type'] = type;
    data['doc_date'] = docDate;
    data['s'] = s;
    data['dd'] = dd;
    data['amt_in_loc_cur'] = amtInLocCur;
    data['lcurr'] = lcurr;
    data['clrng_doc'] = clrngDoc;
    data['text'] = text;
    data['address'] = address;
    data['deleted_at'] = deletedAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
