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
  final int unitReturn;
  final double unitPrice;
  final int lotNo;

  OrderProductItem({
    required this.id,
    required this.product,
    required this.unitNeed,
    required this.unit,
    required this.unitReturn,
    required this.unitPrice,
    required this.lotNo,
  });

  factory OrderProductItem.fromJson(Map<String, dynamic> json) =>
      OrderProductItem(
        id: json['_id'] ?? '',
        product: OrderProductDetail.fromJson(json['productId'] ?? {}),
        unitNeed: json['unitNeed'] ?? 0,
        unit: json['unit'] ?? 0,
        unitReturn: json['unitReturn'] ?? 0,
        unitPrice: (json['unitPrice'] ?? 0).toDouble(),
        lotNo: json['lotNo'] ?? 0,
      );
}

class OrderStoreModel {
  final String id;
  final String name;
  final String storeNumber;
  final String address;
  final String phone;
  final double lat;
  final double lng;

  OrderStoreModel({
    required this.id,
    required this.name,
    required this.storeNumber,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  factory OrderStoreModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['location']?['coordinates'] as List?) ?? [];
    return OrderStoreModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      storeNumber: json['storeNumber'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      lng: coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0,
      lat: coords.length > 1 ? (coords[1] as num).toDouble() : 0.0,
    );
  }
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
