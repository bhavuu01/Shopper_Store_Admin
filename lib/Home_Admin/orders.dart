
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListScreenSeller extends StatefulWidget {
  @override
  OrderListScreenSellerState createState() => OrderListScreenSellerState();
}

class OrderListScreenSellerState extends State<OrderListScreenSeller> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('Orders').snapshots();
  }

  void _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
        'Status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId status updated to $newStatus'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error updating order status: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan,
        title: Text('All Orders',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No orders available."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderId = snapshot.data!.docs[index].id;
              var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var status = orderData['Status'] ?? 'Pending';
              var products = orderData['Items'];
              var userEmail = orderData['UserEmail'];
              var address = orderData['Address'];
              var paymentMethod = orderData['PaymentMethod'];
              var amount = orderData['Amount'];

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: $orderId",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Status: $status",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "User Email: $userEmail",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Address: $address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Payment Method: $paymentMethod",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Amount: $amount",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Products:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          products.length,
                              (index) => Text(
                            "- ${products[index]['Product']} (${products[index]['SelectedQuantity']}x)",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.grey),
                      SizedBox(height: 16),
                      if (status != 'Cancelled') // Conditionally rendering dropdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _updateOrderStatus(orderId, newValue);
                                }
                              },
                              value: status,
                              items: <String>[
                                'Pending',
                                'Order Confirmed',
                                'Shipped',
                                'Out For Delivery',
                                'Delivered',
                                'Cancelled'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            // Additional buttons or widgets can be added here
                          ],
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