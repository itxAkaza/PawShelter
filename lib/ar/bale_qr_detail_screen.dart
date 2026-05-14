import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'gate_pass_controller.dart';
import 'bale_model.dart';

class BaleQrDetailScreen extends StatelessWidget {
  final String baleId;
  const BaleQrDetailScreen({super.key, required this.baleId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GatePassController>();
    controller.streamBale(baleId); // start Firebase live stream

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
        title: const Text('Bale Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      // Only the body reacts to selectedBale changes
      body: Obx(() {
        final bale = controller.selectedBale.value;

        // Loading state
        if (controller.isLoading.value && bale == null) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF58A6FF)));
        }

        // Not found
        if (bale == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
                const SizedBox(height: 16),
                Text('Bale not found: $baleId',
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 15)),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── QR Code Card ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Column(
                  children: [
                    Text('Bale QR Code',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: controller.getQrData(bale),
                        version: QrVersions.auto,
                        size: 180,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(bale.baleNumber,
                        style: const TextStyle(
                            color: blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('Bale ID: ${bale.id}',
                        style: const TextStyle(
                            color: Color(0xFF6E7681), fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Live Firebase Data Card ───────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_done,
                            color: Color(0xFF3FB950), size: 16),
                        const SizedBox(width: 8),
                        const Text('Live Firebase Data',
                            style: TextStyle(
                                color: Color(0xFF3FB950),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1)),
                        const Spacer(),
                        // status badge — uses bale.status (from obs selectedBale)
                        _StatusBadge(status: bale.status),
                      ],
                    ),
                    const Divider(color: Color(0xFF30363D), height: 24),
                    _InfoRow('Item Type', bale.itemType, Icons.category_outlined),
                    _InfoRow('Quantity', '${bale.quantity} ${bale.unit}',
                        Icons.scale_outlined),
                    _InfoRow('Location', bale.currentLocation,
                        Icons.location_on_outlined),
                    _InfoRow('Supplier', bale.supplierName,
                        Icons.business_outlined),
                    _InfoRow('Received', _formatDate(bale.receivedAt),
                        Icons.calendar_today_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Update Location ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Update Location',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ['Gate', 'Warehouse', 'Production', 'Dispatch']
                          .map((loc) {
                        // bale.currentLocation comes from obs selectedBale
                        final isActive = bale.currentLocation == loc;
                        return GestureDetector(
                          onTap: () =>
                              controller.updateBaleLocation(bale.id, loc),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? blue.withOpacity(0.15)
                                  : const Color(0xFF0D1117),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isActive
                                      ? blue
                                      : const Color(0xFF30363D)),
                            ),
                            child: Text(loc,
                                style: TextStyle(
                                    color: isActive
                                        ? blue
                                        : const Color(0xFF8B949E),
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _InfoRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B949E), size: 16),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}