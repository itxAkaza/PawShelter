import 'package:get/get.dart';
import 'gate_pass_model.dart';
import 'bale_model.dart';
import 'gate_pass_repository.dart';

class GatePassController extends GetxController {
  final GatePassRepository _repo = GatePassRepository();

  // ─── State ───────────────────────────────────────────────────
  var gatePasses = <GatePassModel>[].obs;
  var bales = <BaleModel>[].obs;
  var selectedBale = Rxn<BaleModel>();
  var isLoading = false.obs;
  var isCreating = false.obs;
  var errorMsg = ''.obs;
  var filterStatus = 'All'.obs; // 'All', 'IN', 'OUT'

  // ─── Filtered list (computed from gatePasses + filterStatus) ─
  List<GatePassModel> get filteredPasses {
    if (filterStatus.value == 'All') return gatePasses;
    return gatePasses.where((g) => g.status == filterStatus.value).toList();
  }

  // ─── Form Fields ─────────────────────────────────────────────
  var selectedItemType = 'Yarn'.obs;
  var selectedStatus = 'IN'.obs;
  var selectedUnit = 'kg'.obs;

  final itemTypes = ['Yarn', 'Greige Fabric', 'Finished Goods'];
  final statuses = ['IN', 'OUT'];
  final units = ['kg', 'Bales', 'Meters'];

  @override
  void onInit() {
    super.onInit();
    fetchGatePasses();
    fetchBales();
  }

  // ─── Gate Pass ───────────────────────────────────────────────

  void fetchGatePasses() {
    _repo.streamGatePasses().listen((list) {
      gatePasses.value = list;
    });
  }

  Future<void> createGatePass({
    required String baleId,
    required String vehicleNumber,
    required String driverName,
    required int quantity,
  }) async {
    isCreating.value = true;
    errorMsg.value = '';
    try {
      final gatePass = GatePassModel(
        id: '',
        baleId: baleId,
        itemType: selectedItemType.value,
        status: selectedStatus.value,
        vehicleNumber: vehicleNumber,
        driverName: driverName,
        quantity: quantity,
        unit: selectedUnit.value,
        createdAt: DateTime.now(),
        createdBy: 'current_user', // replace with Firebase Auth uid
      );
      await _repo.createGatePass(gatePass);
      Get.back();
      Get.snackbar('Success', 'Gate Pass created successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isCreating.value = false;
    }
  }

  // ─── Bale ────────────────────────────────────────────────────

  Future<void> fetchBales() async {
    isLoading.value = true;
    try {
      bales.value = await _repo.getAllBales();
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void streamBale(String baleId) {
    isLoading.value = true;
    _repo.streamBale(baleId).listen((bale) {
      selectedBale.value = bale;
      isLoading.value = false;
    });
  }

  Future<void> updateBaleLocation(String baleId, String location) async {
    try {
      await _repo.updateBaleLocation(baleId, location);
      Get.snackbar('Updated', 'Bale location updated to $location',
          snackPosition: SnackPosition.BOTTOM);
      fetchBales();
    } catch (e) {
      errorMsg.value = e.toString();
    }
  }

  // QR code data — encode this into QR
  String getQrData(BaleModel bale) {
    return 'BALE:${bale.id}|${bale.baleNumber}|${bale.itemType}|${bale.quantity}${bale.unit}|${bale.currentLocation}|${bale.status}';
  }
}