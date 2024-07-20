import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeScreen.dart';

class AdminWishListScreen extends StatefulWidget {
  const AdminWishListScreen({Key? key}) : super(key: key);

  @override
  State<AdminWishListScreen> createState() => _AdminWishListScreenState();
}

class _AdminWishListScreenState extends State<AdminWishListScreen> {
  // Sample wish list data, replace this with your actual wish list data
  final List<WishList> wishListItems = [
    WishList(id: 1, productName: 'Wish Product 1'),
    WishList(id: 2, productName: 'Wish Product 2'),
    WishList(id: 3, productName: 'Wish Product 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Wish List'),
      ),
      body: ListView.builder(
        itemCount: wishListItems.length,
        itemBuilder: (context, index) {
          final wishListItem = wishListItems[index];
          return ListTile(
            title: Text('Wish ID: ${wishListItem.id}'),
            subtitle: Text('Product: ${wishListItem.productName}'),
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

class WishList {
  final int id;
  final String productName;

  WishList({
    required this.id,
    required this.productName,
  });
}
