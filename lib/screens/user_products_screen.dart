import 'package:flutter/material.dart';
import 'package:myshop/screens/add_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/custom_appbar_all.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

   Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: CustomAppBar2(
  title: 'Your Products',
  actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.add,color: Colors.white,),
      onPressed: () {
        Navigator.of(context).pushNamed(EditProductScreen.routeName);
      },
    ),
  ],
),

      drawer: AppDrawer(),
      body:FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                 UserProductItem(
                      productsData.items[i].id,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                const Divider(),
              ],
            ),
          ),
        ),
          ),
      ))
      );
  }
}
