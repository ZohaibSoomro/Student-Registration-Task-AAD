import 'package:flutter/material.dart';
import 'package:interactive_card/animation/circle_resizer_animation.dart';
import 'package:interactive_card/custom_widgets/RoundedBlackButton.dart';
import 'package:interactive_card/model/card_details.dart';
import 'package:interactive_card/pages/thankyou.dart';

import 'form_text_field.dart';

class CardDetailsForm extends StatefulWidget {
  const CardDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<CardDetailsForm> createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends State<CardDetailsForm> {
  CardDetails cardDetails = CardDetails();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardHolderTextController =
      TextEditingController();
  final TextEditingController cardNumberTextController =
      TextEditingController();
  final TextEditingController expiryMonthTextController =
      TextEditingController();
  final TextEditingController expiryYearTextController =
      TextEditingController();
  final TextEditingController cvcNumberTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormTextField(
              controller: cardHolderTextController,
              label: 'CARDHOLDER NAME',
              hint: 'e.g. Jane Appleseed',
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'input a cardholder name!';
                }
                return null;
              },
            ),
            FormTextField(
              controller: cardNumberTextController,
              label: 'CARD NUMBER',
              hint: 'e.g. 1234 5678 9123 0000',
              maxChars: 16,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'input a card number!';
                }
                return null;
              },
            ),
            Row(
              children: [
                _buildFlexibleTextField(
                  'EXP.MON',
                  'MM',
                  expiryMonthTextController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'input a month!';
                    }
                    if (val.length > 2) {
                      return 'invalid month!';
                    }
                    try {
                      int month = int.parse(val);
                      if (month > 12 || month < 1) throw Exception();
                    } catch (e) {
                      return 'invalid month!';
                    }
                    return null;
                  },
                ),
                _buildFlexibleTextField(
                  'EXP.YEAR',
                  'YY',
                  expiryYearTextController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'input a year!';
                    }
                    if (val.length > 2) {
                      return 'input valid year!';
                    }
                    try {
                      int.parse(val);
                    } catch (e) {
                      return 'year must be number!';
                    }
                    return null;
                  },
                ),
                _buildFlexibleTextField(
                  'CVC#',
                  'e.g. 123',
                  cvcNumberTextController,
                  flex: 2,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'input a cvc!';
                    }
                    if (val.length > 3) {
                      return 'input valid cvc!';
                    }
                    try {
                      int.parse(val);
                    } catch (e) {
                      return 'cvc must be number!';
                    }
                    return null;
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: RoundedBlackButton(
                onPressed: _onConfirmBtnPressed,
                label: 'Confirm',
              ),
            )
          ],
        ),
      ),
    );
  }

  _clearControllers() {
    cardNumberTextController.clear();
    cardHolderTextController.clear();
    expiryMonthTextController.clear();
    expiryYearTextController.clear();
    cvcNumberTextController.clear();
  }

  _onConfirmBtnPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      cardDetails = CardDetails(
        cardHolderName: cardHolderTextController.text.toString(),
        cardNumber: cardNumberTextController.text,
        expiryMonth: expiryMonthTextController.text,
        expiryYear: expiryYearTextController.text,
        cvcNumber: cvcNumberTextController.text,
      );
      if (cardDetails.isNotEmpty()) {
        _clearControllers();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CircleResizerAnimation(
              destination: ThankYouPage(cardDetails: cardDetails),
            ),
          ),
        );
      }
    }
  }

  Flexible _buildFlexibleTextField(
      String label, String hint, TextEditingController controller,
      {int flex = 1, String? Function(String?)? validator}) {
    return Flexible(
      flex: flex,
      child: FormTextField(
        label: label,
        hint: hint,
        controller: controller,
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cardNumberTextController.dispose();
    cardHolderTextController.dispose();
    expiryMonthTextController.dispose();
    expiryYearTextController.dispose();
    cvcNumberTextController.dispose();
  }
}
