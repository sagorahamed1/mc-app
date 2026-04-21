class OrderProductDetail {
  final String id;
  final String itemNo;
  final String name;
  final double price;

  OrderProductDetail({
    required this.id,
    required this.itemNo,
    required this.name,
    required this.price,
  });

  factory OrderProductDetail.fromJson(Map<String, dynamic> json) =>
      OrderProductDetail(
        id: json['_id'] ?? '',
        itemNo: json['itemNo'] ?? '',
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
      );
}

class OrderProductItem {
  final String id;
  final OrderProductDetail product;
  final int unitNeed;
  final int unit;
  final double unitPrice;

  OrderProductItem({
    required this.id,
    required this.product,
    required this.unitNeed,
    required this.unit,
    required this.unitPrice,
  });

  factory OrderProductItem.fromJson(Map<String, dynamic> json) =>
      OrderProductItem(
        id: json['_id'] ?? '',
        product: OrderProductDetail.fromJson(json['productId'] ?? {}),
        unitNeed: json['unitNeed'] ?? 0,
        unit: json['unit'] ?? 0,
        unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      );
}

class OrderStoreModel {
  final String id;
  final String name;
  final String storeNumber;
  final String address;
  final String phone;

  OrderStoreModel({
    required this.id,
    required this.name,
    required this.storeNumber,
    required this.address,
    required this.phone,
  });

  factory OrderStoreModel.fromJson(Map<String, dynamic> json) =>
      OrderStoreModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        storeNumber: json['storeNumber'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
      );
}

class OrderModel {
  final String id;
  final String status;
  final double totalPrice;
  final String palletNo;
  final List<dynamic> stickers;
  final OrderStoreModel store;
  final DateTime createdAt;
  final List<OrderProductItem> products;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.palletNo,
    required this.stickers,
    required this.store,
    required this.createdAt,
    required this.products,
  });

  bool get hasSticker => stickers.isNotEmpty;

  String get displayStatus {
    if (status == 'delivered') {
      return hasSticker ? 'Delivered with sticker' : 'Delivered without sticker';
    }
    return status[0].toUpperCase() + status.substring(1);
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['_id'] ?? '',
        status: json['status'] ?? '',
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        palletNo: json['palletNo'] ?? '',
        stickers: json['stickers'] ?? [],
        store: OrderStoreModel.fromJson(json['store'] ?? {}),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        products: ((json['products'] as List?) ?? [])
            .map((e) => OrderProductItem.fromJson(e))
            .toList(),
      );
}
