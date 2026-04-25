class OrderProductLot {
  final int lotNo;
  final int units;

  OrderProductLot({required this.lotNo, required this.units});

  factory OrderProductLot.fromJson(Map<String, dynamic> json) =>
      OrderProductLot(
        lotNo: json['lotNo'] ?? 0,
        units: json['units'] ?? 0,
      );
}

class OrderProductDetail {
  final String id;
  final String itemNo;
  final String name;
  final double price;
  final int unitPerCase;
  final List<OrderProductLot> productLots;

  OrderProductDetail({
    required this.id,
    required this.itemNo,
    required this.name,
    required this.price,
    required this.unitPerCase,
    required this.productLots,
  });

  factory OrderProductDetail.fromJson(Map<String, dynamic> json) =>
      OrderProductDetail(
        id: json['_id'] ?? '',
        itemNo: json['itemNo'] ?? '',
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        unitPerCase: json['unitPerCase'] ?? 0,
        productLots: ((json['productLots'] as List?) ?? [])
            .map((e) => OrderProductLot.fromJson(e))
            .toList(),
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

class OrderUserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final int sid;

  OrderUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.sid,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) => OrderUserModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        profileImage: json['profileImage'] ?? '',
        sid: json['sid'] ?? 0,
      );
}

class OrderVisitModel {
  final String id;
  final DateTime dateTime;
  final String status;

  OrderVisitModel({
    required this.id,
    required this.dateTime,
    required this.status,
  });

  factory OrderVisitModel.fromJson(Map<String, dynamic> json) => OrderVisitModel(
        id: json['_id'] ?? '',
        dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
        status: json['status'] ?? '',
      );
}

class OrderModel {
  final String id;
  final int sid;
  final String status;
  final double totalPrice;
  final String palletNo;
  final List<dynamic> stickers;
  final String merchandiserId;
  final String storeId;
  final String mmId;
  final String visitId;
  final String waId;
  final String driverId;
  final OrderStoreModel store;
  final OrderUserModel? merchandiser;
  final OrderUserModel? mm;
  final OrderUserModel? wa;
  final OrderUserModel? driver;
  final OrderVisitModel? visit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderProductItem> products;

  OrderModel({
    required this.id,
    required this.sid,
    required this.status,
    required this.totalPrice,
    required this.palletNo,
    required this.stickers,
    required this.merchandiserId,
    required this.storeId,
    required this.mmId,
    required this.visitId,
    required this.waId,
    required this.driverId,
    required this.store,
    this.merchandiser,
    this.mm,
    this.wa,
    this.driver,
    this.visit,
    required this.createdAt,
    required this.updatedAt,
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
        sid: json['sid'] ?? 0,
        status: json['status'] ?? '',
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        palletNo: json['palletNo'] ?? '',
        stickers: json['stickers'] ?? [],
        merchandiserId: json['merchandiserId'] ?? '',
        storeId: json['storeId'] ?? '',
        mmId: json['MMId'] ?? '',
        visitId: json['visitId'] ?? '',
        waId: json['WAId'] ?? '',
        driverId: json['driverId'] ?? '',
        store: OrderStoreModel.fromJson(json['store'] ?? {}),
        merchandiser: json['merchandiser'] != null
            ? OrderUserModel.fromJson(json['merchandiser'])
            : null,
        mm: json['MM'] != null ? OrderUserModel.fromJson(json['MM']) : null,
        wa: json['WA'] != null ? OrderUserModel.fromJson(json['WA']) : null,
        driver: json['driver'] != null
            ? OrderUserModel.fromJson(json['driver'])
            : null,
        visit: json['visit'] != null
            ? OrderVisitModel.fromJson(json['visit'])
            : null,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
        products: ((json['products'] as List?) ?? [])
            .map((e) => OrderProductItem.fromJson(e))
            .toList(),
      );
}
