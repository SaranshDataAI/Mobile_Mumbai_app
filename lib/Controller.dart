// controller.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PriceController extends GetxController {
  var sqrt = ''.obs;
  var bhk = 1.obs;
  var selectedLocation = top20Locations.first.obs;
  var predictedPrice = ''.obs;

  var amenities =
      {
        "New/Resale": false,
        "Lift Available": false,
        "CarParking": false,
        "Gymnasium": false,
        "24x7 Security": false,
        "Swimming Pool": false,
        "Intercom": false,
      }.obs;

  bool isValidSqrt() {
    final value = int.tryParse(sqrt.value);
    return value != null && value >= 100 && value <= 10000;
  }

  Future<void> predictPrice() async {
    if (!isValidSqrt()) {
      predictedPrice.value = "Invalid sqft!";
      HapticFeedback.heavyImpact();
      return;
    }

    final data = {
      'sqrt': int.parse(sqrt.value),
      'bhk': bhk.value,
      'price_per_sqft': 15000,
      ...amenities.map((k, v) => MapEntry(k, v ? 1 : 0)),
    };

    for (var loc in top20Locations) {
      data['location_$loc'] = selectedLocation.value == loc ? 1 : 0;
    }

    try {
      final res = await http.post(
        Uri.parse("https://mumbai-house-app.onrender.com/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (res.statusCode == 200) {
        final result = jsonDecode(res.body);
        final formatter = NumberFormat.decimalPattern('en_IN');
        final formatted = formatter.format(result['predicted_price'].round());
        predictedPrice.value = "Estimated Price: ₹$formatted";
        HapticFeedback.mediumImpact();
      } else {
        predictedPrice.value = "Error: ${res.statusCode}";
      }
    } catch (e) {
      predictedPrice.value = "Failed to connect to API";
    }
  }
}

const top20Locations = [
  "Andheri",
  "Bandra",
  "Borivali",
  "Chembur",
  "Dadar",
  "Goregaon",
  "Juhu",
  "Kandivali",
  "Kurla",
  "Malad",
  "Mulund",
  "Powai",
  "Santacruz",
  "Thane",
  "Vikhroli",
  "Vile Parle",
  "Ghatkopar",
  "Bhandup",
  "Wadala",
  "Khar",
];
