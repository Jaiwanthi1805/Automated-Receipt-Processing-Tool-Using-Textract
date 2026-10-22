import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/upload_service.dart';
import 'receipt_screen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Receipt Processing"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.receipt_long,
              size: 100,
              color: Colors.blue,
            ),


            const SizedBox(height: 20),


            const Text(
              "Upload Your Receipt",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 30),


            ElevatedButton(

                onPressed: () async {


                    final picker = ImagePicker();


                    final image = await picker.pickImage(
                        source: ImageSource.gallery,
                    );


                    if(image != null){

                        File file = File(image.path);


                        var result =
                        await UploadService.uploadReceipt(file);


                        print(result);


                    }


                },

                child: const Text(
                    "Upload Receipt",
                ),

            ),

            const SizedBox(height: 20),

            ElevatedButton(

                onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReceiptScreen(),
                        ),
                    );

                },

                child: const Text(
                    "View Receipts",
                ),

            ),

            

          ],

        ),

      ),

    );
  }
}