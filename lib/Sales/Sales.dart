import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopperstore/Sales/AddSales.dart';
import 'package:shopperstore/Sales/EditSales.dart';
import 'package:shopperstore/Sales/SalesModel.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  void _deleteSale(String saleID) {
    FirebaseFirestore.instance.collection('Sales').doc(saleID).delete().then((value) {
      Fluttertoast.showToast(
        msg: 'Sale Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete sale',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Sales',style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
         ),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyan),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    onChanged: (value){
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.cyan),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              SalesList(deleteSale: _deleteSale,),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSales(),));
      },
        child: Icon(Icons.add,color: Colors.black,size: 25,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class SalesList extends StatelessWidget {

  final Function(String) deleteSale;
  const SalesList({Key? key, required this.deleteSale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Sales').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final saleDocs = snapshot.data!.docs;
          List<SalesModel> sales = [];

          for (var doc in saleDocs) {
            final sale = SalesModel.fromSnapshot(doc);
            sales.add(sale);
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10),
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(sale.sales, style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),
                        ),
                      ),
                      // const Spacer(),

                      // const Spacer(),
                      const SizedBox(height: 10,),
                      Center(
                        child: Image.network(
                            sale.image, width: 300, height: 200),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => EditSales(sales: sale, image: sale.image,),));
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.cyan),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion',),
                                        content: const Text(
                                            'Are you sure you want to delete this sale?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Dismiss the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteSale(sale.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Delete', style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
