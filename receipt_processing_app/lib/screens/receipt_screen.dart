import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/receipt.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  late Future<List<Receipt>> receipts;

  @override
  void initState() {
    super.initState();
    receipts = ApiService.getReceipts();
  }


  void deleteReceipt(String receiptId) async {

  print("Deleting receipt: $receiptId");

  bool deleted = await ApiService.deleteReceipt(receiptId);

  print("Delete response: $deleted");

    if(deleted){

      setState(() {
        receipts = ApiService.getReceipts();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Receipt deleted successfully"),
        ),
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Receipts"),

        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {

              setState(() {
                receipts = ApiService.getReceipts();
              });

            },
          ),

        ],
      ),


      body: FutureBuilder<List<Receipt>>(

        future: receipts,

        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(),
            );

          }


          if(snapshot.hasError){

            return Center(
              child: Text(snapshot.error.toString()),
            );

          }


          final data = snapshot.data!;


          return ListView.builder(

            itemCount: data.length,

            itemBuilder: (context,index){

              final receipt = data[index];


              return Card(

                child: ListTile(

                  title: Text(receipt.merchant),


                  trailing: IconButton(

                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),


                    onPressed: () {

                      showDialog(

                        context: context,

                        builder: (context){

                          return AlertDialog(

                            title: const Text("Delete Receipt"),

                            content: const Text(
                              "Are you sure you want to delete this receipt?"
                            ),


                            actions: [

                              TextButton(

                                onPressed: (){
                                  Navigator.pop(context);
                                },

                                child: const Text("Cancel"),

                              ),


                              TextButton(

                                onPressed: (){

                                  Navigator.pop(context);

                                  deleteReceipt(
                                    receipt.receiptId
                                  );

                                },

                                child: const Text(
                                  "Delete"
                                ),

                              ),

                            ],

                          );

                        },

                      );

                    },

                  ),



                  subtitle: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text("Date: ${receipt.date}"),

                      Text("Amount: ₹${receipt.amount}"),

                      const SizedBox(height:10),


                      const Text(
                        "Items:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                      ...receipt.items.map(

                        (item){

                          if(item is String){

                            return Text("• $item");

                          }

                          else if(item is Map){

                            return Text(
                              "• ${item['name'] ?? ''} ${item['price'] ?? ''}",
                            );

                          }

                          else{

                            return const Text(
                              "• Unknown item"
                            );

                          }

                        },

                      ),

                    ],

                  ),

                ),

              );

            },

          );

        },

      ),

    );

  }

}