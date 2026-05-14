import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gate_pass_controller.dart';

class CreateGatePassScreen extends StatelessWidget {
  const CreateGatePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GatePassController>();
    final baleIdCtrl = TextEditingController();
    final vehicleCtrl = TextEditingController();
    final driverCtrl = TextEditingController();
    final quantityCtrl = TextEditingController();

    const bg = Color(0xFF0D1117);
    const surface = Color(0xFF161B22);
    const border = Color(0xFF30363D);
    const blue = Color(0xFF58A6FF);
    const green = Color(0xFF238636);

    InputDecoration fieldDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
        prefixIcon: Icon(icon, color: blue, size: 20),
        filled: true,
        fillColor: surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Create Gate Pass',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: blue.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: blue, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Fill in the gate pass details. A QR code will be generated automatically.',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel('Item Details'),
            const SizedBox(height: 12),

            // Item Type Dropdown
            Obx(() => _DropdownField(
                  label: 'Item Type',
                  icon: Icons.category_outlined,
                  value: controller.selectedItemType.value,
                  items: controller.itemTypes,
                  onChanged: (v) => controller.selectedItemType.value = v!,
                )),
            const SizedBox(height: 14),

            // Status IN/OUT
            Obx(() => Row(
                  children: controller.statuses.map((s) {
                    final active = controller.selectedStatus.value == s;
                    final color =
                        s == 'IN' ? const Color(0xFF3FB950) : const Color(0xFFF85149);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectedStatus.value = s,
                        child: Container(
                          margin: EdgeInsets.only(right: s == 'IN' ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: active ? color.withOpacity(0.15) : surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: active ? color : border, width: active ? 1.5 : 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  s == 'IN'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: active ? color : const Color(0xFF8B949E),
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(s,
                                  style: TextStyle(
                                      color: active ? color : const Color(0xFF8B949E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 14),

            // Bale ID
            TextField(
              controller: baleIdCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: fieldDecoration('Bale ID', Icons.qr_code),
            ),
            const SizedBox(height: 14),

            // Quantity + Unit Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: quantityCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: fieldDecoration('Quantity', Icons.numbers),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _DropdownField(
                        label: 'Unit',
                        icon: Icons.straighten,
                        value: controller.selectedUnit.value,
                        items: controller.units,
                        onChanged: (v) => controller.selectedUnit.value = v!,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _SectionLabel('Vehicle Details'),
            const SizedBox(height: 12),

            TextField(
              controller: vehicleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: fieldDecoration('Vehicle Number', Icons.local_shipping_outlined),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: driverCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: fieldDecoration('Driver Name', Icons.person_outline),
            ),

            const SizedBox(height: 32),

            // Error
            Obx(() => controller.errorMsg.value.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF85149).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF85149).withOpacity(0.3)),
                    ),
                    child: Text(controller.errorMsg.value,
                        style: const TextStyle(color: Color(0xFFF85149), fontSize: 13)),
                  )
                : const SizedBox()),

            // Submit Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: controller.isCreating.value
                        ? null
                        : () {
                            if (baleIdCtrl.text.isEmpty ||
                                vehicleCtrl.text.isEmpty ||
                                driverCtrl.text.isEmpty ||
                                quantityCtrl.text.isEmpty) {
                              controller.errorMsg.value = 'Please fill all fields';
                              return;
                            }
                            controller.createGatePass(
                              baleId: baleIdCtrl.text.trim(),
                              vehicleNumber: vehicleCtrl.text.trim(),
                              driverName: driverCtrl.text.trim(),
                              quantity: int.tryParse(quantityCtrl.text) ?? 0,
                            );
                          },
                    child: controller.isCreating.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Create Gate Pass',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Color(0xFF8B949E),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2));
  }
}

class _DropdownField extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF161B22),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
        prefixIcon: Icon(icon, color: const Color(0xFF58A6FF), size: 20),
        filled: true,
        fillColor: const Color(0xFF161B22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF58A6FF)),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
