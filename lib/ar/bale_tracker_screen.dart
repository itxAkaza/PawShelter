import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gate_pass_controller.dart';
import 'bale_model.dart';
import 'bale_qr_detail_screen.dart';

class BaleTrackerScreen extends StatelessWidget {
  const BaleTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GatePassController>();
    controller.fetchBales();

    const bg = Color(0xFF0D1117);
    const surface = Color(0xFF161B22);
    const blue = Color(0xFF58A6FF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Bale Tracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: blue),
            onPressed: controller.fetchBales,
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Summary
          Obx(() => _LocationSummary(bales: controller.bales)),

          // Bale List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: blue));
              }
              if (controller.bales.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 64, color: Colors.grey[700]),
                      const SizedBox(height: 16),
                      Text('No bales tracked yet',
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.bales.length,
                itemBuilder: (_, i) {
                  final bale = controller.bales[i];
                  return _BaleCard(
                    bale: bale,
                    onTap: () =>
                        Get.to(() => BaleQrDetailScreen(baleId: bale.id)),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LocationSummary extends StatelessWidget {
  final List<BaleModel> bales;
  const _LocationSummary({required this.bales});

  int _count(String loc) =>
      bales.where((b) => b.currentLocation == loc).length;

  @override
  Widget build(BuildContext context) {
    final locations = {
      'Gate': const Color(0xFF58A6FF),
      'Warehouse': const Color(0xFFD29922),
      'Production': const Color(0xFF3FB950),
      'Dispatch': const Color(0xFFF85149),
    };

    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LOCATION OVERVIEW',
              style: TextStyle(
                  color: Color(0xFF8B949E),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: locations.entries.map((e) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: e.value.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: e.value.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text('${_count(e.key)}',
                          style: TextStyle(
                              color: e.value,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(e.key,
                          style: TextStyle(
                              color: e.value.withOpacity(0.8), fontSize: 10),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BaleCard extends StatelessWidget {
  final BaleModel bale;
  final VoidCallback onTap;
  const _BaleCard({required this.bale, required this.onTap});

  Color get _locationColor {
    switch (bale.currentLocation) {
      case 'Gate':
        return const Color(0xFF58A6FF);
      case 'Warehouse':
        return const Color(0xFFD29922);
      case 'Production':
        return const Color(0xFF3FB950);
      case 'Dispatch':
        return const Color(0xFFF85149);
      default:
        return const Color(0xFF8B949E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Row(
          children: [
            // Location indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: _locationColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(bale.baleNumber,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      _StatusBadge(status: bale.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(bale.itemType,
                      style: const TextStyle(
                          color: Color(0xFF8B949E), fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: _locationColor, size: 13),
                      const SizedBox(width: 4),
                      Text(bale.currentLocation,
                          style: TextStyle(
                              color: _locationColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('${bale.quantity} ${bale.unit}',
                          style: const TextStyle(
                              color: Color(0xFF58A6FF),
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.qr_code_2, color: Color(0xFF30363D), size: 28),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'available':
        color = const Color(0xFF3FB950);
        break;
      case 'in-use':
        color = const Color(0xFFD29922);
        break;
      default:
        color = const Color(0xFF8B949E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
