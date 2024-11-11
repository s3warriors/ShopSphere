import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:myshop/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
         Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 136, 116, 169),
                    Color.fromARGB(255, 55, 25, 104),
                    Color.fromARGB(255, 116, 72, 120),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.only(top: 40), // Adjust padding as needed
              child: AppBar(
                backgroundColor: Colors.transparent, // Make AppBar background transparent
                title: const Text(
                  'Hello Friend!',
                  style: TextStyle(color: Colors.white),
                ),
                automaticallyImplyLeading: false,
                elevation: 0, // Remove shadow under AppBar
              ),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop', style:TextStyle(fontSize: 15, color: Colors.black),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders', style:TextStyle(fontSize: 15, color: Colors.black)),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
            Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products', style:TextStyle(fontSize: 15, color: Colors.black)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
           const Divider(),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text('Process Orders', style:TextStyle(fontSize: 15, color: Colors.black)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
           const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
              
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
