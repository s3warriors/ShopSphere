import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// import '../widgets/cart_item.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;
  final String creatorId;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.creatorId,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;
  Orders(this.authToken, this.userId, List list);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://myshop-3abca-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url as Uri);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          creatorId: userId!,
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => cartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<cartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://myshop-3abca-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
        'creatorId': userId!,
      }),
    );

    final orderId = json.decode(response.body)['name'];

    // Insert the new order at the beginning of the list
    _orders.insert(
      0,
      OrderItem(
        id: orderId,
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
        creatorId: userId!,
      ),
    );

    // Update each product in the cart, adding the orderId to their 'orders' list
//   for (var cp in cartProducts) {
//   final productUrl = Uri.parse(
//     'https://myshop-3abca-default-rtdb.firebaseio.com/products/${cp.id}.json?auth=$authToken');
  
//   print('In product and order edit phase **********************$cp.id');
  
//   try {
//     // Fetch the current product data to get the existing orders
//     final productResponse = await http.get(productUrl);

//     // Check if the response is valid
//     if (productResponse.statusCode == 200) {
//       final productData = json.decode(productResponse.body);

//       // Add the new orderId to the existing orders list
//       final updatedOrders = List<String>.from(productData['orders'] ?? []);
//       updatedOrders.add(orderId);

//       // Update the product with the new orders list
//       final patchResponse = await http.patch(
//         productUrl,
//         body: json.encode({
//           'orders': updatedOrders, // Update the orders array with the new orderId
//         }),
//       );

//       // Check if the PATCH request was successful
//       if (patchResponse.statusCode != 200) {
//         throw Exception('Failed to update product orders');
//       }

//       print('Product orders updated successfully!');
//     } else {
//       throw Exception('Failed to fetch product data');
//     }
//   } catch (error) {
//     print('Error while updating product: $error');
//     throw error;
//   }
// }


    notifyListeners();
  }
}
