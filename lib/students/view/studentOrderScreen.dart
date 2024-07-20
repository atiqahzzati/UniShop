import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeScreen.dart';
import 'package:fluttercalendar_app/admin/view/adminWishListScreen.dart';

class StudentOrderScreen extends StatefulWidget {
  const StudentOrderScreen({Key? key}) : super(key: key);

  @override
  State<StudentOrderScreen> createState() => _StudentOrderScreenState();
}

class _StudentOrderScreenState extends State<StudentOrderScreen> {
  // Sample order data, replace this with your actual order data
  final List<Order> orders = [
    Order(id: 1, productName: 'Product 1', quantity: 2),
    Order(id: 2, productName: 'Product 2', quantity: 3),
    Order(id: 3, productName: 'Product 3', quantity: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Order ID: ${order.id}'),
            subtitle: Text('Product: ${order.productName}, Quantity: ${order.quantity}'),
          );
        },
      ),
       bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromARGB(255, 199, 178, 142), // Set unselected icon color
        selectedItemColor: Color.fromARGB(255, 100, 17, 17), // Set selected icon color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wish List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              // Navigate to the AdminHomeScreen when "Home" tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHomeScreen()),
              );
              break;
            case 1:
              // Navigate to the AdminWishListScreen when "Wish List" tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminWishListScreen()),
              );
              break;
            case 2:
              // Handle Order tab, stay on the current screen
              break;
            case 3:
              // Navigate to the AdminLoginScreen when "Login" tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHomeScreen()),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class Order {
  final int id;
  final String productName;
  final int quantity;

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
  });
}
