import 'package:flutter/material.dart';
import 'package:student_registration_aad/database/customer_db_helper.dart';

import '../custom_widgets/my_alert_box.dart';
import '../custom_widgets/rounded_button.dart';
import '../custom_widgets/rounded_text_field.dart';
import '../model/customer.dart';
import 'ProductsHome.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  bool customerNumberValidated = false;
  String customerNumber = "";
  final MyAlertBox alertBox = MyAlertBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Login',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          customerLoginForm(),
        ],
      ),
    );
  }

  Form customerLoginForm() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            RoundedTextField(
              labelText: 'Customer Number',
              autoFocus: true,
              suffixIcon: textFieldSuffixIcon(
                customerNumberValidated,
                customerNumberValidated
                    ? 'customer number is valid'
                    : 'invalid customer number!',
                customerNumber,
              ),
              onChanged: customerNumberValidator,
            ),
            const SizedBox(height: 20),
            RoundedButton(
              onPressed: onLoginButtonPressed,
              text: 'Login',
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldSuffixIcon(bool validated, String tooltip, String fieldName) {
    return validated
        ? Tooltip(
            message: tooltip,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          )
        : fieldName.isNotEmpty
            ? Tooltip(
                message: tooltip,
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              )
            : const Text('');
  }

  void customerNumberValidator(value) async {
    customerNumber = value;
    try {
      int.parse(customerNumber);
      customerNumberValidated = true;
    } catch (e) {
      alertBox.showAlertBox(
          context, 'Customer number should be a positive number!');
      customerNumberValidated = false;
      return;
    }

    setState(() {});
  }

  void onLoginButtonPressed() async {
    if (customerNumber.trim() == "") {
      alertBox.showAlertBox(context, "Customer number can't be empty!");
      return;
    }
    if (!customerNumberValidated) {
      alertBox.showAlertBox(
        context,
        "Invalid $customerNumber!",
      );
      return;
    }
    Customer? customer;
    // try {
    customer = await CustomerDbHelper().getCustomer(int.parse(customerNumber));
    print(customer);
    // } catch (e) {
    //   print("Error: $e");
    // }
    if (customer != null) {
      await alertBox.showAlertBox(
        context,
        'Login Successful',
        labelColor: Colors.blue,
        disposeAfterMillis: 500,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsHome(
            customer: customer!,
          ),
        ),
      );
    } else {
      alertBox.showAlertBox(
        context,
        "No record found for customer number $customerNumber!",
      );
    }
  }
}
