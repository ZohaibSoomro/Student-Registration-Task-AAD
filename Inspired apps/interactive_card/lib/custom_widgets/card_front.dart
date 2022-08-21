import 'package:flutter/material.dart';

import '../model/card_details.dart';

class CardFrontContainer extends StatelessWidget {
  const CardFrontContainer({Key? key, this.cardDetails}) : super(key: key);
  final CardDetails? cardDetails;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Image.asset(
          'assets/images/bg-card-front.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: const CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(0xFF6540D0),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  buildText(getCardNumberPart(partNo: 1)),
                  buildText(getCardNumberPart(partNo: 2)),
                  buildText(getCardNumberPart(partNo: 3)),
                  buildText(getCardNumberPart(partNo: 4)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  buildText(
                    cardDetails?.cardHolderName?.toUpperCase() ?? 'YOUR NAME',
                    size: 12,
                    opacity: 0.8,
                  ),
                  buildGapBwNameAndExpiry(context),
                  buildText(
                    '${cardDetails?.expiryMonth?.toUpperCase() ?? '00'}/${cardDetails?.expiryYear?.toUpperCase() ?? '00'}',
                    size: 12,
                    opacity: 0.8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox buildGapBwNameAndExpiry(BuildContext context) {
    if (cardDetails == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.34,
      );
    }
    if (cardDetails!.cardHolderName != null &&
        cardDetails!.cardHolderName!.length <= 10) {
      return SizedBox(
        width: MediaQuery.of(context).size.width /
            (cardDetails!.cardHolderName!.length * 0.35),
      );
    } else if (cardDetails!.cardHolderName != null &&
        cardDetails!.cardHolderName!.length <= 15) {
      return SizedBox(
        width: MediaQuery.of(context).size.width /
            (cardDetails!.cardHolderName!.length * 0.3),
      );
    }

    return SizedBox(
        // width:cardDetails?.cardHolderName!.length>12? MediaQuery.of(context).size.width * 0.35,
        );
  }

  String getCardNumberPart({int partNo = 1}) {
    if (cardDetails == null) {
      return '0000';
    } else {
      final cardNumber = cardDetails?.cardNumber;
      if (cardNumber == null || cardNumber.length > 16) {
        return '0000';
      }
    }
    String part = '';
    switch (partNo) {
      case 1:
        part = cardDetails!.cardNumber?.substring(0, 4) ?? '0000';
        break;
      case 2:
        part = cardDetails!.cardNumber?.substring(4, 8) ?? '0000';
        break;
      case 3:
        part = cardDetails!.cardNumber?.substring(8, 12) ?? '0000';
        break;
      case 4:
        part = cardDetails!.cardNumber?.substring(12, 16) ?? '0000';
        break;
      default:
        part = '0000';
    }
    return part;
  }

  Widget buildText(String text, {double size = 20, double opacity = 1}) => Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(opacity),
              fontSize: size,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 15),
        ],
      );
}
