import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nfc_card/enums/card_enum.dart';
import 'package:nfc_card/gen/assets.gen.dart';
import 'package:nfc_card/screens/widgets/debit_credit_card_widget.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cardDataNotifier = ValueNotifier<Map<String, dynamic>?>(null);

  @override
  void initState() {
    super.initState();
    startNewSession();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  void startNewSession() {
    cardDataNotifier.value = null;
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        cardDataNotifier.value = tag.data;
        if (tag.data.containsKey("isodep") && tag.data['isodep']['cardNumber'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Too fast, Try again")));
        } else {
          NfcManager.instance.stopSession();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (cardDataNotifier.value == null) {
          return true;
        }
        startNewSession();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: Center(
              child: Text.rich(TextSpan(text: "Made with ❤️ by Tamil Kannan C V", children: [
            const TextSpan(text: " • "),
            TextSpan(
              text: "Licenses",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showLicensePage(context: context);
                },
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          ]))),
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: NfcManager.instance.isAvailable(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return CustomScrollView(
                  slivers: [
                    const SliverAppBar.medium(
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text("credit/debit card details via NFC"),
                        titlePadding: EdgeInsets.all(8.0),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ValueListenableBuilder(
                        valueListenable: cardDataNotifier,
                        builder: (context, value, child) {
                          if (value != null && value.containsKey("isodep") && value['isodep']['cardNumber'] != null) {
                            Logger().d(value['isodep']['cardType']);

                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              child: Dismissible(
                                key: const ValueKey("card"),
                                onDismissed: (direction) {
                                  startNewSession();
                                },
                                child: DebitCreditCardWidget(
                                  color1: Colors.black,
                                  color2: Colors.grey.shade900,
                                  cardNumber: (value['isodep']['cardNumber'] as String?)?.replaceRange(4, 12, "XXXXXXXX") ?? "0000000000000000",
                                  cardExpiry: value['isodep']['cardExpiryDate']?.replaceAll("/", "") ?? "0000",
                                  cardHolderName: (value['isodep']['cardHolderFirstName'] ?? "") + " " + (value['isodep']['cardHolderLastName'] ?? ""),
                                  cardBrand: CardBrand.values.firstWhere(
                                    (element) => element.name.toLowerCase() == value['isodep']['cardType']?.toLowerCase(),
                                    orElse: () => CardBrand.visa,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.lotties.nfc.lottie(),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "scanning, keep your card near nfc until your card is detected",
                                    style: TextStyle(fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.data == false) {
                return const CustomScrollView(
                  slivers: [
                    SliverAppBar.medium(
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text("credit/debit card details via NFC"),
                        titlePadding: EdgeInsets.all(8.0),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text("This device does not support NFC"),
                      ),
                    ),
                  ],
                );
              }
              return const CustomScrollView(
                slivers: [
                  SliverAppBar.medium(
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text("credit/debit card details via NFC"),
                      titlePadding: EdgeInsets.all(8.0),
                    ),
                    backgroundColor: Colors.transparent,
                    bottom: PreferredSize(preferredSize: Size.fromHeight(0), child: LinearProgressIndicator()),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
