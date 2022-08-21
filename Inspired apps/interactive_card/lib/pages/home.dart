import 'package:flutter/material.dart';
import 'package:interactive_card/custom_widgets/card_back_container.dart';
import 'package:interactive_card/custom_widgets/card_details_form.dart';
import 'package:interactive_card/custom_widgets/card_front.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                    top: MediaQuery.of(context).size.width * 0.17,
                  ),
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: const CardBackContainer(),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    top: MediaQuery.of(context).size.height * 0.24,
                  ),
                  child: const CardFrontContainer(),
                ),
              ],
            ),
            const CardDetailsForm(),
          ],
        ),
      ),
    );
  }
}
