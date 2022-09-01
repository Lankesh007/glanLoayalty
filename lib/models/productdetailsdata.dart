class ProductDetailsData {
  int errorCode;
  String errorMessage;
  Response response;

  ProductDetailsData({this.errorCode, this.errorMessage, this.response});

  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    response = json['Response'] != null
        ? Response.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  List<Images> images;
  Details details;
  int avalableStock;
  int cartQuantity;
  GroupPrice groupPrice;

  Response(
      {this.images,
        this.details,
        this.avalableStock,
        this.cartQuantity,
        this.groupPrice});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    avalableStock = json['avalable_stock'];
    cartQuantity = json['cart_quantity'];
    groupPrice = json['group_price'] != null
        ? new GroupPrice.fromJson(json['group_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    data['avalable_stock'] = this.avalableStock;
    data['cart_quantity'] = this.cartQuantity;
    if (this.groupPrice != null) {
      data['group_price'] = this.groupPrice.toJson();
    }
    return data;
  }
}

class Images {
  String image;

  Images({this.image});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class Details {
  int id;
  int restaurantId;
  int parentItemId;
  int expiryType;
  int isFeatured;
  String itemName;
  String productCode;
  int brandId;
  int categoryId;
  int taxId;
  String itemPrice;
  String itemLength;
  String itemWidth;
  String itemHeight;
  String itemWeight;
  String discountPrice;
  int returnDays;
  String distributorDiscountPrice;
  int warrantyMonth;
  String barcode;
  String shortDescription;
  String orderLimit;
  String itemType;
  String image;
  String longDescription;
  String cardColor;
  String fontColor;
  String manufacturerId;
  String manufacturer;
  String shelfId;
  String sortOrder;
  int enabled;
  String dealerLoyaltyPoints;
  String distributorLoyaltyPoints;
  String createdAt;
  String updatedAt;
  String deleteAt;
  String productImage;

  Details(
      {this.id,
        this.restaurantId,
        this.parentItemId,
        this.expiryType,
        this.isFeatured,
        this.itemName,
        this.productCode,
        this.brandId,
        this.categoryId,
        this.taxId,
        this.itemPrice,
        this.itemLength,
        this.itemWidth,
        this.itemHeight,
        this.itemWeight,
        this.discountPrice,
        this.returnDays,
        this.distributorDiscountPrice,
        this.warrantyMonth,
        this.barcode,
        this.shortDescription,
        this.orderLimit,
        this.itemType,
        this.image,
        this.longDescription,
        this.cardColor,
        this.fontColor,
        this.manufacturerId,
        this.manufacturer,
        this.shelfId,
        this.sortOrder,
        this.enabled,
        this.dealerLoyaltyPoints,
        this.distributorLoyaltyPoints,
        this.createdAt,
        this.updatedAt,
        this.deleteAt,
        this.productImage});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    parentItemId = json['parent_item_id'];
    expiryType = json['expiry_type'];
    isFeatured = json['is_featured'];
    itemName = json['item_name'];
    productCode = json['product_code'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    taxId = json['tax_id'];
    itemPrice = json['item_price'];
    itemLength = json['item_length'];
    itemWidth = json['item_width'];
    itemHeight = json['item_height'];
    itemWeight = json['item_weight'];
    discountPrice = json['discount_price'];
    returnDays = json['return_days'];
    distributorDiscountPrice = json['distributor_discount_price'];
    warrantyMonth = json['warranty_month'];
    barcode = json['barcode'];
    shortDescription = json['short_description'];
    orderLimit = json['order_limit'];
    itemType = json['item_type'];
    image = json['image'];
    longDescription = json['long_description'];
    cardColor = json['card_color'];
    fontColor = json['font_color'];
    manufacturerId = json['manufacturer_id'];
    manufacturer = json['manufacturer'];
    shelfId = json['shelf_id'];
    sortOrder = json['sort_order'];
    enabled = json['enabled'];
    dealerLoyaltyPoints = json['dealer_loyalty_points'];
    distributorLoyaltyPoints = json['distributor_loyalty_points'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deleteAt = json['delete_at'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['parent_item_id'] = this.parentItemId;
    data['expiry_type'] = this.expiryType;
    data['is_featured'] = this.isFeatured;
    data['item_name'] = this.itemName;
    data['product_code'] = this.productCode;
    data['brand_id'] = this.brandId;
    data['category_id'] = this.categoryId;
    data['tax_id'] = this.taxId;
    data['item_price'] = this.itemPrice;
    data['item_length'] = this.itemLength;
    data['item_width'] = this.itemWidth;
    data['item_height'] = this.itemHeight;
    data['item_weight'] = this.itemWeight;
    data['discount_price'] = this.discountPrice;
    data['return_days'] = this.returnDays;
    data['distributor_discount_price'] = this.distributorDiscountPrice;
    data['warranty_month'] = this.warrantyMonth;
    data['barcode'] = this.barcode;
    data['short_description'] = this.shortDescription;
    data['order_limit'] = this.orderLimit;
    data['item_type'] = this.itemType;
    data['image'] = this.image;
    data['long_description'] = this.longDescription;
    data['card_color'] = this.cardColor;
    data['font_color'] = this.fontColor;
    data['manufacturer_id'] = this.manufacturerId;
    data['manufacturer'] = this.manufacturer;
    data['shelf_id'] = this.shelfId;
    data['sort_order'] = this.sortOrder;
    data['enabled'] = this.enabled;
    data['dealer_loyalty_points'] = this.dealerLoyaltyPoints;
    data['distributor_loyalty_points'] = this.distributorLoyaltyPoints;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delete_at'] = this.deleteAt;
    data['product_image'] = this.productImage;
    return data;
  }
}

class GroupPrice {
  int id;
  int userId;
  int productId;
  int quantity;
  String rate;
  String offerPrice;
  String amount;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int avaliableStock;
  String groupPrice;

  GroupPrice(
      {this.id,
        this.userId,
        this.productId,
        this.quantity,
        this.rate,
        this.offerPrice,
        this.amount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.avaliableStock,
        this.groupPrice});

  GroupPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    rate = json['rate'];
    offerPrice = json['offer_price'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    avaliableStock = json['avaliable_stock'];
    groupPrice = json['group_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['offer_price'] = this.offerPrice;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['avaliable_stock'] = this.avaliableStock;
    data['group_price'] = this.groupPrice;
    return data;
  }
}