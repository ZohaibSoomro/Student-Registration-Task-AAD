import 'package:flutter/material.dart';
import 'package:interactive_card/custom_widgets/RoundedBlackButton.dart';
import 'package:interactive_card/custom_widgets/card_back_container.dart';
import 'package:interactive_card/custom_widgets/card_front.dart';
import 'package:interactive_card/model/card_details.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({Key? key, required this.cardDetails}) : super(key: key);
  final CardDetails cardDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: 10,
                    top: MediaQuery.of(context).size.width * 0.16,
                  ),
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: CardBackContainer(
                    cardDetails: cardDetails,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    top: MediaQuery.of(context).size.height * 0.19,
                  ),
                  child: CardFrontContainer(
                    cardDetails: cardDetails,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF6540D0),
                    radius: 40,
                    child: Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'THANK YOU!',
                        style: TextStyle(fontSize: 40, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "We've added your card details.",
                      style: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: RoundedBlackButton(
                      onPressed: () {},
                      label: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
