import 'package:cloud_firestore/cloud_firestore.dart';
import 'gate_pass_model.dart';
import 'bale_model.dart';

class GatePassRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Gate Pass ───────────────────────────────────────────────

  Future<void> createGatePass(GatePassModel gatePass) async {
    await _firestore.collection('gatePasses').add(gatePass.toMap());
  }

  Future<List<GatePassModel>> getAllGatePasses() async {
    final snapshot = await _firestore
        .collection('gatePasses')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => GatePassModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<GatePassModel>> streamGatePasses() {
    return _firestore
        .collection('gatePasses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GatePassModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ─── Bale ────────────────────────────────────────────────────

  Future<void> createBale(BaleModel bale) async {
    await _firestore.collection('bales').doc(bale.id).set(bale.toMap());
  }

  Future<BaleModel?> getBaleById(String baleId) async {
    final doc = await _firestore.collection('bales').doc(baleId).get();
    if (!doc.exists) return null;
    return BaleModel.fromMap(doc.data()!, doc.id);
  }

  Future<List<BaleModel>> getAllBales() async {
    final snapshot = await _firestore
        .collection('bales')
        .orderBy('receivedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BaleModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateBaleLocation(String baleId, String newLocation) async {
    await _firestore.collection('bales').doc(baleId).update({
      'currentLocation': newLocation,
    });
  }

  Future<void> updateBaleStatus(String baleId, String status) async {
    await _firestore.collection('bales').doc(baleId).update({
      'status': status,
    });
  }

  Stream<BaleModel?> streamBale(String baleId) {
    return _firestore.collection('bales').doc(baleId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return BaleModel.fromMap(doc.data()!, doc.id);
    });
  }
}
