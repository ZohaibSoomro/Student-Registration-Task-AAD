import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/custom_widgets/my_alert_box.dart';
import 'package:student_registration_aad/model/product.dart';

import '../students_info/products_provider_model.dart';

class CartProducts extends StatefulWidget {
  const CartProducts({Key? key}) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  Widget build(BuildContext context) {
    final cartList = Provider.of<ProductsProviderModel>(context, listen: false)
        .cartProductsList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products in cart'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProductsProviderModel>(context, listen: false)
                  .clearCart();
              MyAlertBox().showAlertBox(
                context,
                'Cart reset done.',
                disposeAfterMillis: 1000,
                labelColor: Colors.blue,
              );
              setState(() {});
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) {
          Product product = cartList[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    '${product.productImageUrl}',
                    scale: 0.1,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                tileColor: Colors.blue,
                title: Text(
                  product.productName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Code:${product.productCode}\nPrice: \$${product.buyPrice}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Provider.of<ProductsProviderModel>(context, listen: false)
                        .removeFromCartAt(index);
                    MyAlertBox().showAlertBox(
                      context,
                      'Product removed from cart successfully.',
                      disposeAfterMillis: 1000,
                      labelColor: Colors.blue,
                    );
                    setState(() {});
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                )),
          );
        },
      ),
    );
  }
}
