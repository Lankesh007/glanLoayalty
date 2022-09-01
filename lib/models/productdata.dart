class ProductData {
  int errorCode;
  String errorMessage;
  ItemResponse itemResponse;

  ProductData({this.errorCode, this.errorMessage, this.itemResponse});

  ProductData.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    itemResponse = json['ItemResponse'] != null
        ? new ItemResponse.fromJson(json['ItemResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    if (this.itemResponse != null) {
      data['ItemResponse'] = this.itemResponse.toJson();
    }
    return data;
  }
}

class ItemResponse {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  ItemResponse(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ItemResponse.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int productId;
  String shortDescription;
  int parentItemId;
  String productName;
  String productImage;
  String mrp;
  String orderLimit;
  String discountPrice;
  String discountPercentage;
  int currentStock;
  int isStock;
  int quantity;
  String itemDiscount;
  String groupPrice;

  Data(
      {this.productId,
        this.shortDescription,
        this.parentItemId,
        this.productName,
        this.productImage,
        this.mrp,
        this.orderLimit,
        this.discountPrice,
        this.discountPercentage,
        this.currentStock,
        this.isStock,
        this.quantity,
        this.itemDiscount,
        this.groupPrice});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    shortDescription = json['short_description'];
    parentItemId = json['parent_item_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    mrp = json['mrp'];
    orderLimit = json['order_limit'];
    discountPrice = json['discount_price'];
    discountPercentage = json['discount_percentage'].toString();
    currentStock = json['current_stock'];
    isStock = json['is_stock'];
    quantity = json['quantity'];
    itemDiscount = json['item_discount'];
    groupPrice = json['group_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['short_description'] = this.shortDescription;
    data['parent_item_id'] = this.parentItemId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['mrp'] = this.mrp;
    data['order_limit'] = this.orderLimit;
    data['discount_price'] = this.discountPrice;
    data['discount_percentage'] = this.discountPercentage;
    data['current_stock'] = this.currentStock;
    data['is_stock'] = this.isStock;
    data['quantity'] = this.quantity;
    data['item_discount'] = this.itemDiscount;
    data['group_price'] = this.groupPrice;
    return data;
  }
}