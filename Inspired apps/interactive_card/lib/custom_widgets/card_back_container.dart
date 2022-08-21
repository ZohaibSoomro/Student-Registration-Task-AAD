import 'package:flutter/material.dart';
import 'package:interactive_card/model/card_details.dart';

class CardBackContainer extends StatelessWidget {
  const CardBackContainer({
    Key? key,
    this.cardDetails,
  }) : super(key: key);
  final CardDetails? cardDetails;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Image.asset(
          'assets/images/bg-card-back.png',
        ),
        Positioned(
          right: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.width * 0.185,
          child: Text(
            cardDetails?.cvcNumber ?? '000',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
