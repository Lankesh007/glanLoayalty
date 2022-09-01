class CartlistData {
  int errorCode;
  String errorMessage;
  Response response;

  CartlistData({this.errorCode, this.errorMessage, this.response});

  CartlistData.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    response = json['Response'] != null
        ? new Response.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int totalPrice;
  List<Items> items;
  List<Cart> cart;
  int deliveryFee;
  int total;
  String address;

  Response(
      {this.totalPrice,
        this.items,
        this.cart,
        this.deliveryFee,
        this.total,
        this.address});

  Response.fromJson(Map<String, dynamic> json) {
    totalPrice = json['total_price'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart.add(new Cart.fromJson(v));
      });
    }
    deliveryFee = json['delivery_fee'];
    total = json['total'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_price'] = this.totalPrice;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
    }
    data['delivery_fee'] = this.deliveryFee;
    data['total'] = this.total;
    data['address'] = this.address;
    return data;
  }
}

class Items {
  int id;
  String shortDescription;
  String image;
  String productName;
  int cartId;
  int quantity;
  String rate;
  String amount;
  String offerPrice;
  int productId;
  String productImage;
  int avaliableStock;
  String groupPrice;

  Items(
      {this.id,
        this.shortDescription,
        this.image,
        this.productName,
        this.cartId,
        this.quantity,
        this.rate,
        this.amount,
        this.offerPrice,
        this.productId,
        this.productImage,
        this.avaliableStock,
        this.groupPrice});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortDescription = json['short_description'];
    image = json['image'];
    productName = json['product_name'];
    cartId = json['cart_id'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    offerPrice = json['offer_price'];
    productId = json['product_id'];
    productImage = json['product_image'];
    avaliableStock = json['avaliable_stock'];
    groupPrice = json['group_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['product_name'] = this.productName;
    data['cart_id'] = this.cartId;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['offer_price'] = this.offerPrice;
    data['product_id'] = this.productId;
    data['product_image'] = this.productImage;
    data['avaliable_stock'] = this.avaliableStock;
    data['group_price'] = this.groupPrice;
    return data;
  }
}

class Cart {
  int id;
  String shortDescription;
  String itemName;

  Cart({this.id, this.shortDescription, this.itemName});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortDescription = json['short_description'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_description'] = this.shortDescription;
    data['item_name'] = this.itemName;
    return data;
  }
}