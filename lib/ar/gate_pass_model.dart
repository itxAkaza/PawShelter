class GatePassModel {
  final String id;
  final String baleId;
  final String itemType; // yarn, greige, finished
  final String status; // IN, OUT
  final String vehicleNumber;
  final String driverName;
  final int quantity;
  final String unit; // kg, bales
  final DateTime createdAt;
  final String createdBy;

  GatePassModel({
    required this.id,
    required this.baleId,
    required this.itemType,
    required this.status,
    required this.vehicleNumber,
    required this.driverName,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    required this.createdBy,
  });

  factory GatePassModel.fromMap(Map<String, dynamic> map, String docId) {
    return GatePassModel(
      id: docId,
      baleId: map['baleId'] ?? '',
      itemType: map['itemType'] ?? '',
      status: map['status'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      driverName: map['driverName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? 'kg',
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baleId': baleId,
      'itemType': itemType,
      'status': status,
      'vehicleNumber': vehicleNumber,
      'driverName': driverName,
      'quantity': quantity,
      'unit': unit,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
