class StoreModel {
  final String id;
  final String name;
  final String phone;
  final String storeNumber;
  final String address;

  StoreModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.storeNumber,
    required this.address,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        storeNumber: json['storeNumber'] ?? '',
        address: json['address'] ?? '',
      );
}

class VisitModel {
  final String id;
  final String status;
  final String displayStatus;
  final DateTime dateTime;
  final StoreModel store;
  final DateTime? lastVisitAt;
  final bool isRescheduleSubmitted;

  VisitModel({
    required this.id,
    required this.status,
    required this.displayStatus,
    required this.dateTime,
    required this.store,
    this.lastVisitAt,
    required this.isRescheduleSubmitted,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) => VisitModel(
        id: json['_id'] ?? '',
        status: json['status'] ?? '',
        displayStatus: json['displayStatus'] ?? '',
        dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
        store: StoreModel.fromJson(json['store'] ?? {}),
        lastVisitAt: json['lastVisitAt'] != null
            ? DateTime.tryParse(json['lastVisitAt'])
            : null,
        isRescheduleSubmitted: json['isRescheduleSubmitted'] ?? false,
      );

  bool get isTimeOver =>
      status == 'pending' && DateTime.now().isAfter(dateTime);

  VisitModel copyWith({String? status, String? displayStatus}) => VisitModel(
        id: id,
        status: status ?? this.status,
        displayStatus: displayStatus ?? this.displayStatus,
        dateTime: dateTime,
        store: store,
        lastVisitAt: lastVisitAt,
        isRescheduleSubmitted: isRescheduleSubmitted,
      );
}
