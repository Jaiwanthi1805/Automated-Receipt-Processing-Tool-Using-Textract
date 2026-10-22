import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static Future<Map<String, dynamic>> uploadReceipt(File image) async {
    const String apiUrl =
        "https://4i7opwyucf.execute-api.us-east-1.amazonaws.com/prodd/upload";

    try {
      // Step 1: Request a presigned upload URL
      final response = await http.post(Uri.parse(apiUrl));

      print("POST Status Code: ${response.statusCode}");
      print("POST Response: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Failed to get upload URL");
      }

      final data = jsonDecode(response.body);

      if (!data.containsKey("uploadUrl")) {
        throw Exception("uploadUrl not found in API response");
      }

      final String uploadUrl = data["uploadUrl"];

      // Step 2: Upload image to S3
      final bytes = await image.readAsBytes();

      final uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          "Content-Type": "image/jpeg",
        },
        body: bytes,
      );

      print("S3 Upload Status Code: ${uploadResponse.statusCode}");
      print("S3 Upload Response: ${uploadResponse.body}");

      if (uploadResponse.statusCode != 200) {
        throw Exception("Image upload to S3 failed");
      }

      print("Upload completed successfully.");

      return data;
    } catch (e) {
      print("Upload Error: $e");
      rethrow;
    }
  }
}