import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_card/gen/assets.gen.dart';
import 'package:nfc_card/gen/fonts.gen.dart';

import '../../enums/card_enum.dart';

class DebitCreditCardWidget extends StatelessWidget {
  final double? width;
  final String cardHolderName;
  final String cardNumber;
  final String cardExpiry;
  final String? validFrom;
  final BoxDecoration? cardDecoration;
  final Color textColor;
  final Color color2;
  final Color color1;
  final bool showNFC;
  final ImageProvider<Object>? cardBrandImage;
  final CardBrand cardBrand;
  final CardType cardType;
  final String customCardType;
  final DecorationImage? backgroundDecorationImage;
  final ImageProvider<Object>? customCompanyImage;
  const DebitCreditCardWidget({
    super.key,
    this.width,
    this.cardHolderName = "John Doe",
    this.cardNumber = "0000000000000000",
    this.cardExpiry = "0000",
    this.cardDecoration,
    this.textColor = Colors.white,
    this.validFrom,
    this.color2 = Colors.black,
    this.color1 = Colors.pinkAccent,
    this.showNFC = true,
    this.cardBrand = CardBrand.visa,
    this.cardBrandImage,
    this.cardType = CardType.debit,
    this.customCardType = "DEBIT",
    this.customCompanyImage,
    this.backgroundDecorationImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: (width ?? MediaQuery.of(context).size.width),
        height: ((width ?? MediaQuery.of(context).size.width)) * 0.56574,
        child: Card(
            margin: const EdgeInsets.all(0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
                decoration: cardDecoration ??
                    BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      image: backgroundDecorationImage,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: const Alignment(0.6, 1.7),
                        colors: [color1, color2],
                        tileMode: TileMode.repeated,
                      ),
                    ),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getCardTypeString(cardType, customCardType), style: TextStyle(fontSize: 16, color: textColor)),
                          customCompanyImage == null
                              ? Container()
                              : Image(
                                  image: customCompanyImage!,
                                  height: (width ?? MediaQuery.of(context).size.width) / 13,
                                ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image(
                            image: Assets.images.chipLogo.provider(),
                            height: (width ?? MediaQuery.of(context).size.width) / 11,
                          ),
                          Visibility(
                            visible: showNFC,
                            child: Image(
                              color: textColor,
                              image: Assets.images.contactlessLogo.provider(),
                              height: (width ?? MediaQuery.of(context).size.width) / 15,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("For security reasons, card number is masked")));
                        },
                        child: Text(
                          StringUtils.addCharAtPosition(cardNumber.toString(), " ", 4, repeat: true),
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 3,
                            fontFamily: FontFamily.kredit,
                            color: textColor,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Visibility(
                                    visible: validFrom != null,
                                    child: Row(
                                      children: <Widget>[
                                        Text("VALID\nFROM", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: textColor)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          StringUtils.addCharAtPosition(validFrom.toString(), "/", 2),
                                          style: TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 2,
                                            fontFamily: FontFamily.kredit,
                                            color: textColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: validFrom != null,
                                      child: const SizedBox(
                                        width: 50,
                                      )),
                                  Row(
                                    children: <Widget>[
                                      Text("VALID\nTHRU", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: textColor)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(StringUtils.addCharAtPosition(cardExpiry.toString(), "/", 2),
                                          style: TextStyle(fontSize: 22, letterSpacing: 2, fontFamily: FontFamily.kredit, color: textColor))
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                cardHolderName,
                                style: TextStyle(fontSize: 20, fontFamily: FontFamily.kredit, color: textColor),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          Image(image: getCardBrandImage(cardBrand, cardBrandImage ?? Assets.images.visaLogo.provider()), width: 65)
                        ],
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ))));
  }

  String getCardTypeString(CardType cardType, String customCardType) {
    switch (cardType) {
      case CardType.debit:
        return "DEBIT";
      case CardType.credit:
        return "CREDIT";
      case CardType.custom:
        return customCardType;
    }
  }

  ImageProvider<Object> getCardBrandImage(CardBrand cartType, ImageProvider<Object> customCardImage) {
    switch (cartType) {
      case CardBrand.mastercard:
        return Assets.images.mastercardLogo.provider();
      case CardBrand.visa:
        return Assets.images.visaLogo.provider();
      case CardBrand.americanExpress:
        return Assets.images.americanExpressLogo.provider();
      case CardBrand.discover:
        return Assets.images.discoverLogo.provider();
      case CardBrand.rupay:
        return Assets.images.rupayLogo.provider();
      case CardBrand.custom:
        return customCardImage;
    }
  }
}
