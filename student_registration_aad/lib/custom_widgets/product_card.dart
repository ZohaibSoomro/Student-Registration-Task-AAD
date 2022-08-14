import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/custom_widgets/my_alert_box.dart';

import '../model/product.dart';
import '../students_info/products_provider_model.dart';

class ProductCard extends StatelessWidget {
  ProductCard({Key? key, required this.product, this.setState})
      : super(key: key);

  final Product product;
  final MyAlertBox _alertBox = MyAlertBox();
  final VoidCallback? setState;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'productImage',
      child: InkWell(
        splashColor: Colors.amber,
        onTap: () => _onProductTapped(context),
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: product.productImageUrl == null
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        // child: Image.network(
                        //   product.productImageUrl!,
                        //   height: 120,
                        //   width: 150,
                        //   fit: BoxFit.cover,
                        //   colorBlendMode: BlendMode.darken,
                        // ),
                        child: const FlutterLogo(
                          size: 100,
                          style: FlutterLogoStyle.markOnly,
                        ),
                      ),
              ),
              Text(
                product.productName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                '\$${product.buyPrice}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<ProductsProviderModel>(context, listen: false)
                        .addToCart(product);
                    if (setState != null) {
                      setState!();
                    }
                    _alertBox.showAlertBox(
                      context,
                      'Product added to cart.',
                      labelColor: Colors.blue,
                      disposeAfterMillis: 700,
                    );
                  },
                  child: const Text('Add to cart'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onProductTapped(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Center(child: const Text('Product Info.')),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'productImage',
                child: Center(
                  child: Image.network(
                    '${product.productImageUrl}',
                    height: 100,
                  ),
                ),
              ),
              _buildRichText('Code: ', product.productCode),
              _buildRichText('Name: ', product.productName),
              _buildRichText('Price: ', '\$${product.buyPrice}'),
              _buildRichText(
                'Quantity in stock: ',
                '${product.quantityInStock}',
              ),
              _buildRichText('MSRP: ', '${product.MSRP}'),
              _buildRichText('Vendor: ', product.productVendor),
              _buildRichText('Description: ', product.productDescription),
            ],
          ),
        );
      },
    );
  }

  RichText _buildRichText(String fieldName, String value) {
    return RichText(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: fieldName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
