import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopperstore/Auth/login.dart';
import 'package:shopperstore/Sales/Sales.dart';
import 'package:shopperstore/Products/products.dart';
import 'package:shopperstore/Category/category.dart';
import 'package:shopperstore/Home_Admin/orders.dart';
import 'package:shopperstore/Brands/brands.dart';
import 'package:shopperstore/Home_Admin/users.dart';

import 'Provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            // SystemNavigator.pop();
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: const Text(
              'ShopperStore',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.cyan,
            centerTitle: true,
            // automaticallyImplyLeading: false,
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.cyan),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.cyan,
                        radius: 35,
                        child: Image.asset(
                          "asset/images/shopping.png",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: const Text('Orders'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.nightlight),
                  title: const Text('Theme'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Logout"),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                              (route) => false);
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.star_rate),
                  title: const Text('Rate Us'),
                  onTap: () {},
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Center(
                Image.asset(
                  "asset/images/mobileshopping.png",
                  height: 100,
                ),

                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: List.generate(6, (index) {
                      List<Map<String, dynamic>> cardData = [
                        {
                          "image": "asset/images/application.png",
                          "text": "Category",
                          "onTap": _openCategoryScreen,
                        },
                        {
                          "image": "asset/images/categories.png",
                          "text": "Brands",
                          "onTap": _openSubCategoryScreen,
                        },
                        {
                          "image": "asset/images/product.png",
                          "text": "Products",
                          "onTap": _openProductsScreen,
                        },
                        {
                          "image": "asset/images/sale.png",
                          "text": "Sales",
                          "onTap": _openBannerScreen,
                        },
                        {
                          "image": "asset/images/orders.png",
                          "text": "Orders",
                          "onTap": _openOrderScreen,
                        },
                        {
                          "image": "asset/images/users.png",
                          "text": "Users",
                          "onTap": _openUsersScreen,
                        },
                      ];
                      return GestureDetector(
                        onTap: cardData[index]["onTap"],
                        child: Card(
                          color: Colors.cyan[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                cardData[index]["image"],
                                height: 48.0,
                                width: 48.0,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                cardData[index]["text"],
                                style: const TextStyle(fontSize: 17.0,color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _openCategoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CategoryScreen()),
    );
  }

  void _openSubCategoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SubCategoryScreen()),
    );
  }

  void _openProductsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProductScreen()),
    );
  }

  void _openBannerScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SalesScreen()),
    );
  }

  void _openOrderScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const OrdersScreen()),
    );
  }

  void _openUsersScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UsersScreen()),
    );
  }
}
