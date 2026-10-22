import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receipt.dart';

class ApiService {

  static const String baseUrl =
      "https://4i7opwyucf.execute-api.us-east-1.amazonaws.com/prodd";


  // Get all receipts
  static Future<List<Receipt>> getReceipts() async {

    final response = await http.get(
      Uri.parse("$baseUrl/receipts"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data
          .map((json) => Receipt.fromJson(json))
          .toList();

    } else {

      throw Exception("Failed to load receipts");

    }
  }


  // Delete a receipt
  static Future<bool> deleteReceipt(String receiptId) async {

    print("Deleting ID: $receiptId");

    final response = await http.delete(
      Uri.parse("$baseUrl/$receiptId"),
    );

    print("Delete Status: ${response.statusCode}");
    print("Delete Response: ${response.body}");

    return response.statusCode == 200;
  }

}