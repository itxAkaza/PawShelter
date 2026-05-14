import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gate_pass_controller.dart';
import 'gate_pass_model.dart';
import 'create_gate_pass_screen.dart';
import 'qr_scanner_screen.dart';
import 'bale_tracker_screen.dart';

class GatePassListScreen extends StatelessWidget {
  const GatePassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GatePassController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TexOps',
                style: TextStyle(
                    color: Color(0xFF58A6FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2)),
            Text('Gate Pass Manager',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF58A6FF)),
            onPressed: () => Get.to(() => const QrScannerScreen()),
            tooltip: 'Scan QR',
          ),
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Color(0xFF58A6FF)),
            onPressed: () => Get.to(() => const BaleTrackerScreen()),
            tooltip: 'Bale Tracker',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Row — each chip has its own Obx, only that chip rebuilds
          Container(
            color: const Color(0xFF161B22),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Obx(() => _StatChip(
                  label: 'Total',
                  value: controller.gatePasses.length.toString(),
                  color: const Color(0xFF58A6FF),
                )),
                const SizedBox(width: 12),
                Obx(() => _StatChip(
                  label: 'IN',
                  value: controller.gatePasses
                      .where((g) => g.status == 'IN')
                      .length
                      .toString(),
                  color: const Color(0xFF3FB950),
                )),
                const SizedBox(width: 12),
                Obx(() => _StatChip(
                  label: 'OUT',
                  value: controller.gatePasses
                      .where((g) => g.status == 'OUT')
                      .length
                      .toString(),
                  color: const Color(0xFFF85149),
                )),
              ],
            ),
          ),

          // Filter Tabs — uses StatefulWidget locally, no obs needed
          _FilterTabs(controller: controller),

          // List — one Obx for the whole list area (isLoading + gatePasses both obs)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF58A6FF)));
              }
              if (controller.filteredPasses.isEmpty) {
                return _EmptyState();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredPasses.length,
                itemBuilder: (_, i) =>
                    _GatePassCard(gatePass: controller.filteredPasses[i]),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF238636),
        onPressed: () => Get.to(() => const CreateGatePassScreen()),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Gate Pass',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatefulWidget {
  final GatePassController controller;
  const _FilterTabs({required this.controller});

  @override
  State<_FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<_FilterTabs> {
  int _selected = 0;
  final tabs = ['All', 'IN', 'OUT'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = _selected == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.controller.filterStatus.value = tabs[i];
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF238636) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active
                        ? const Color(0xFF238636)
                        : const Color(0xFF30363D)),
              ),
              child: Text(tabs[i],
                  style: TextStyle(
                      color: active ? Colors.white : const Color(0xFF8B949E),
                      fontSize: 13,
                      fontWeight:
                      active ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        }),
      ),
    );
  }
}

class _GatePassCard extends StatelessWidget {
  final GatePassModel gatePass;
  const _GatePassCard({required this.gatePass});

  @override
  Widget build(BuildContext context) {
    final isIn = gatePass.status == 'IN';
    final statusColor =
    isIn ? const Color(0xFF3FB950) : const Color(0xFFF85149);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          isIn
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: statusColor,
                          size: 14),
                      const SizedBox(width: 4),
                      Text(gatePass.status,
                          style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(gatePass.createdAt),
                  style: const TextStyle(
                      color: Color(0xFF8B949E), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.inventory_2,
                    color: Color(0xFF58A6FF), size: 16),
                const SizedBox(width: 8),
                Text(gatePass.itemType,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${gatePass.quantity} ${gatePass.unit}',
                    style: const TextStyle(
                        color: Color(0xFF58A6FF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    color: Color(0xFF8B949E), size: 14),
                const SizedBox(width: 6),
                Text(gatePass.vehicleNumber,
                    style: const TextStyle(
                        color: Color(0xFF8B949E), fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.person_outline,
                    color: Color(0xFF8B949E), size: 14),
                const SizedBox(width: 6),
                Text(gatePass.driverName,
                    style: const TextStyle(
                        color: Color(0xFF8B949E), fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Bale: ${gatePass.baleId}',
                style: const TextStyle(
                    color: Color(0xFF6E7681), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text('No Gate Passes Yet',
              style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          const SizedBox(height: 8),
          Text('Tap + to create the first gate pass',
              style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        ],
      ),
    );
  }
}