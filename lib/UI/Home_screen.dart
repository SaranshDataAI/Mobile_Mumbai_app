// ui/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(PriceController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏠 Mumbai Price Predictor"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed:
                () => Get.snackbar(
                  "About",
                  "This app predicts house prices in Mumbai using machine learning. Adjusted for 13.5% annual inflation over 7 years.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.grey.shade900,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(10),
                  duration: const Duration(seconds: 4),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("📍 Location"),
            buildCard(
              Obx(
                () => DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedLocation.value,
                  items:
                      top20Locations
                          .map(
                            (loc) =>
                                DropdownMenuItem(value: loc, child: Text(loc)),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedLocation.value = val!,
                ),
              ),
            ),

            buildSectionTitle("📏 Square Footage"),
            buildCard(
              Obx(
                () => TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter sqft (100 - 10000)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorText: controller.isValidSqrt() ? null : "Invalid sqft",
                  ),
                  onChanged: (val) => controller.sqrt.value = val,
                ),
              ),
            ),

            buildSectionTitle("🛏 BHK"),
            buildCard(
              Obx(
                () => DropdownButton<int>(
                  isExpanded: true,
                  value: controller.bhk.value,
                  items: List.generate(
                    10,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text("${i + 1} BHK"),
                    ),
                  ),
                  onChanged: (val) => controller.bhk.value = val!,
                ),
              ),
            ),

            buildSectionTitle("🛠 Amenities"),
            buildCard(
              Column(
                children:
                    controller.amenities.keys
                        .map(
                          (a) => Obx(
                            () => SwitchListTile(
                              title: Text(a),
                              value: controller.amenities[a]!,
                              onChanged: (val) => controller.amenities[a] = val,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: controller.predictPrice,
                icon: const Icon(Icons.calculate),
                label: const Text("Predict Price"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Obx(
              () =>
                  controller.predictedPrice.value.isEmpty
                      ? const SizedBox.shrink()
                      : Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.teal.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                controller.predictedPrice.value,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget buildCard(Widget child) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.grey.shade900,
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );
}
