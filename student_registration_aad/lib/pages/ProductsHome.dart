import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_registration_aad/database/product_db_helper.dart';
import 'package:student_registration_aad/pages/CartProductsPage.dart';
import 'package:student_registration_aad/pages/customer_login.dart';

import '../custom_widgets/product_card.dart';
import '../model/customer.dart';
import '../model/product.dart';
import '../students_info/products_provider_model.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({required this.customer});
  final Customer customer;
  @override
  State<ProductsHome> createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  String? categorySelected;
  ProductDbHelper productDbHelper = ProductDbHelper();
  List<Product> productsList = [];

  final productImagesUrlStr = 'https://fakestoreapi.com/products';
  @override
  void initState() {
    super.initState();
    initProductsList();
  }

  initProductsList() async {
    productsList = await productDbHelper.getProductsList();
    await _initProductsImagesList();
    setState(() {});
  }

  _initProductsImagesList() async {
    final resp = await http.get(Uri.parse(productImagesUrlStr));
    final data = jsonDecode(resp.body);
    List<String> productImagesList = [];
    for (var productData in data) {
      String productImage = productData['image'];
      productImagesList.add(productImage);
    }
    for (int i = 0; i < productsList.length; i++) {
      productsList[i].productImageUrl =
          productImagesList[i % productImagesList.length];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back Mr. ${widget.customer.customerFirstName}!'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartProducts(),
                  ),
                );
                setState(() {});
              },
              icon: buildCartIcon(),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categories:'),
                const SizedBox(width: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: ProductDbHelper.productLines.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Row(
                      children: [
                        buildFilterChip(ProductDbHelper.productLines[index]),
                        const SizedBox(width: 2),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.arrow_forward, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(top: 2),
            child: getProductList().isEmpty
                ? null
                : Text('Products count: ${getProductList().length}'),
          ),
          getProductList().isEmpty
              //that means screen is loading very first time
              ? categorySelected == null
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const Expanded(child: Center(child: Text('No Records!')))
              : Expanded(
                  child: GridView.builder(
                    itemCount: getProductList().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => ProductCard(
                      product: getProductList()[index],
                      setState: () => setState(() {}),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerLogin()),
        ),
        child: Icon(Icons.logout),
        tooltip: 'log out',
      ),
    );
  }

  Badge buildCartIcon() {
    return Badge(
      badgeColor: Colors.white,
      position: BadgePosition.topEnd(),
      padding: const EdgeInsets.all(3),
      badgeContent: Text(
        '${Provider.of<ProductsProviderModel>(context, listen: false).cartLength}',
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
      child: const Icon(
        Icons.shopping_cart,
        size: 30,
      ),
    );
  }

  FilterChip buildFilterChip(String filterText) {
    return FilterChip(
      label: Text(filterText),
      labelStyle: const TextStyle(color: Colors.white),
      onSelected: (value) {
        if (categorySelected == filterText) {
          categorySelected = null;
        } else {
          categorySelected = filterText;
        }
        getProductList();
        setState(() {});
      },
      backgroundColor:
          categorySelected == filterText ? Colors.blue : Colors.grey[500],
    );
  }

  List<Product> getProductList() {
    List<Product> pList = [];
    if (categorySelected != null) {
      pList = productsList
          .where((product) => product.productLine == categorySelected)
          .toList();
    } else {
      pList = productsList;
    }
    return pList;
  }
}
