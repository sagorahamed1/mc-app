class ProductStoreModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  ProductStoreModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory ProductStoreModel.fromJson(Map<String, dynamic> json) =>
      ProductStoreModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
      );
}

class ProductModel {
  final String id;
  final String itemNo;
  final String logo;
  final String name;
  final String description;
  final String category;
  final double price;
  final int unitPerCase;
  final int totalUnit;
  final String ownershipModel;
  final String companyName;
  final DateTime? lastOrderedAt;
  final int lastOrderUnit;

  ProductModel({
    required this.id,
    required this.itemNo,
    required this.logo,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.unitPerCase,
    required this.totalUnit,
    required this.ownershipModel,
    required this.companyName,
    this.lastOrderedAt,
    required this.lastOrderUnit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'] ?? '',
        itemNo: json['itemNo'] ?? '',
        logo: json['logo'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        unitPerCase: json['unitPerCase'] ?? 0,
        totalUnit: json['totalUnit'] ?? 0,
        ownershipModel: json['ownershipModel'] ?? '',
        companyName: json['companyName'] ?? '',
        lastOrderedAt: json['lastOrderedAt'] != null
            ? DateTime.tryParse(json['lastOrderedAt'])
            : null,
        lastOrderUnit: json['lastOrderUnit'] ?? 0,
      );
}
