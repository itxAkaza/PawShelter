class BaleModel {
  final String id;
  final String baleNumber;
  final String itemType;
  final String currentLocation; // Gate, Warehouse, Production, Dispatch
  final int quantity;
  final String unit;
  final String supplierId;
  final String supplierName;
  final DateTime receivedAt;
  final String status; // available, in-use, dispatched

  BaleModel({
    required this.id,
    required this.baleNumber,
    required this.itemType,
    required this.currentLocation,
    required this.quantity,
    required this.unit,
    required this.supplierId,
    required this.supplierName,
    required this.receivedAt,
    required this.status,
  });

  factory BaleModel.fromMap(Map<String, dynamic> map, String docId) {
    return BaleModel(
      id: docId,
      baleNumber: map['baleNumber'] ?? '',
      itemType: map['itemType'] ?? '',
      currentLocation: map['currentLocation'] ?? '',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? 'kg',
      supplierId: map['supplierId'] ?? '',
      supplierName: map['supplierName'] ?? '',
      receivedAt: DateTime.parse(map['receivedAt']),
      status: map['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baleNumber': baleNumber,
      'itemType': itemType,
      'currentLocation': currentLocation,
      'quantity': quantity,
      'unit': unit,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'receivedAt': receivedAt.toIso8601String(),
      'status': status,
    };
  }
}
