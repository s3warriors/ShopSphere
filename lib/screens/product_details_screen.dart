// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetalsScreen extends StatelessWidget {
  // final String title;

  // ProductDetalsScreen(this.title);
  static const routename = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    //   print('kya hai bhaiya');
    // if (productId == null) {
    //   print('null hai bhaiya');
    //   Navigator.of(context).pop();
    // }
    final cart = Provider.of<Cart>(context, listen: false);
    final loadedProduct =
        Provider.of<Products>(context, listen: false).getId(productId);
    // print(loadedProduct);
    //we can extract al details of product using this id
    return Scaffold(
      body:
//        SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Hero(
//                 tag: LoadedProduct.id,
//                 child: Image.network(
//                   LoadedProduct.imageUrl,
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Price: \$${LoadedProduct.price}',
//               style: const TextStyle(
//                 color: Colors.black54,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               width: double.infinity,
//               child: Text('Description: ${LoadedProduct.description}',

//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600 , ),
//                 // textAlign: TextAlign.center,
//                 softWrap: true,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
          //     CustomScrollView(
          //   slivers: <Widget>[
          //     SliverAppBar(
          //       backgroundColor: Theme.of(context).primaryColor,
          //       expandedHeight: 300,
          //       pinned: true,
          //       flexibleSpace: FlexibleSpaceBar(
          //         title:  Text(
          //             loadedProduct.title,
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 20,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),

          //         background: Hero(
          //           tag: loadedProduct.id,
          //           child: Image.network(
          //             loadedProduct.imageUrl,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //     ),
          //     SliverList(
          //       delegate: SliverChildListDelegate(
          //         [
          //           const SizedBox(height: 10),
          //           Text(
          //             '\$${loadedProduct.price}',
          //             style: const TextStyle(
          //               color: Colors.grey,
          //               fontSize: 20,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           Container(
          //             padding: const EdgeInsets.symmetric(horizontal: 10),
          //             width: double.infinity,
          //             child: Text(
          //               loadedProduct.description,
          //               textAlign: TextAlign.center,
          //               softWrap: true,
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 800,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
  backgroundColor: Theme.of(context).primaryColor,
  expandedHeight: 200,
  pinned: true,
  flexibleSpace: FlexibleSpaceBar(
    title: Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      // decoration: BoxDecoration(
      //   color: Colors.black.withOpacity(0.6), // Semi-transparent background
      //   borderRadius: BorderRadius.circular(4),
      // ),
      child: Text(
        loadedProduct.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          shadows: [
            Shadow(
              blurRadius: 6.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        // textAlign: TextAlign.center,
      ),
    ),
    background: Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: loadedProduct.id,
          child: Image.network(
            loadedProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        // Dark overlay to increase contrast
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
,
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Product Description Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        loadedProduct.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      // Price Section
                      Text(
                        '\$${loadedProduct.price}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              cart.addItems(loadedProduct.id,
                                  loadedProduct.title, loadedProduct.price);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added item to cart!',
                                  ),
                                  duration: Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      cart.removeSingleItem(loadedProduct.id);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Add to Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          // const SizedBox(width: 20),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Buy Now functionality
                          //   },
                          //   child: const Text("Buy Now",style: TextStyle(color: Colors.white)),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.orange,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Add spacing at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
