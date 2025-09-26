import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tarot/app/controllers/card_controller.dart';
import 'package:tarot/app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile
              return MobileLayout();
            } else if (constraints.maxWidth < 1024) {
              // Tablet
              return WebLayout();
            } else {
              // Web / Desktop
              return WebLayout();
            }
          },
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  MobileLayout({Key? key}) : super(key: key);
  final cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meow Tarot",
          style: GoogleFonts.aladin(
            textStyle: TextStyle(
              fontSize: Get.textTheme.headlineLarge!.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Close your eyes, reflect, ask yourself a question.\nThen choose 3 cards.",
                style: Get.textTheme.bodyMedium!.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () {
                cardController.selectedCard.clear();
                cardController.shuffleList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Text("Shuffle"),
                  Icon(Icons.shuffle),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Center(
                child: SizedBox(
                  height: 300,
                  width: Get.width * 0.9,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children:
                        cardController.cardList.asMap().entries.map((entry) {
                      final index = entry.key; // index from 0..length-1
                      final card = entry.value; // your card object if needed

                      double cardWidth = 150;
                      double totalCards =
                          cardController.cardList.length.toDouble();
                      double spread = 6; // space between cards
                      double center = (Get.width * 0.9 - cardWidth) / 2;
                      double middleIndex = (totalCards - 1) / 2;

                      double left = center +
                          (index - middleIndex) *
                              spread *
                              cardController.position.value;

                      return AnimatedPositioned(
                        key: ValueKey(card), // important for shuffle animation
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        left: left,
                        bottom: cardController.selectedCard.contains(index)
                            ? 50
                            : 0,
                        child: InkWell(
                          splashColor: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => cardController.toggleSelectCard(index),
                          child: cardController.selectedCard.contains(index)
                              ? Hero(
                                  tag: "selected_$index",
                                  child: CardBackSide(
                                    width: 150,
                                  ),
                                )
                              : CardBackSide(
                                  width: 150,
                                ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                if (cardController.selectedCard.length == 3) {
                  Get.toNamed(AppRoutes.RESULT);
                }
              },
              child: Text(
                cardController.selectedCard.length == 3
                    ? "See Result"
                    : "${cardController.selectedCard.length}/ 3 selected",
                style: Get.theme.textTheme.bodyLarge,
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Created By Yell Htet Kyaw"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'mgyehtetkyaw@gmail.com',
                        );
                        await launchUrl(emailLaunchUri);
                      },
                      icon: Icon(Icons.email),
                    ),
                    IconButton(
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            "https://www.linkedin.com/in/yellhtetkyaw"));
                      },
                      icon: Icon(BoxIcons.bxl_linkedin),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await launchUrl(
                            Uri.parse("https://www.github.com/y3llkyaw"),
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      icon: Icon(BoxIcons.bxl_github),
                    ),
                  ],
                ),
                Text("Powered By Flutter"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WebLayout extends StatelessWidget {
  WebLayout({Key? key}) : super(key: key);
  final cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meow Tarot",
          style: GoogleFonts.aladin(
            textStyle: TextStyle(
              fontSize: Get.textTheme.headlineLarge!.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Close your eyes, reflect, ask yourself a question. Then click the button to get your cards.",
                style: Get.textTheme.bodyLarge!.copyWith(
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () {
                cardController.selectedCard.clear();
                cardController.shuffleList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Text("Shuffle"),
                  Icon(Icons.shuffle),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                height: 400,
                width: Get.width * 0.9,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children:
                      cardController.cardList.asMap().entries.map((entry) {
                    final index = entry.key; // index from 0..length-1
                    final card = entry.value; // your card object if needed

                    double cardWidth = 200;
                    double totalCards =
                        cardController.cardList.length.toDouble();
                    double spread = 30; // space between cards
                    double center = (Get.width * 0.9 - cardWidth) / 2;
                    double middleIndex = (totalCards - 1) / 2;

                    double left = center +
                        (index - middleIndex) *
                            spread *
                            cardController.position.value;

                    return AnimatedPositioned(
                      key: ValueKey(card), // important for shuffle animation
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: left,
                      bottom:
                          cardController.selectedCard.contains(index) ? 50 : 0,
                      child: InkWell(
                        splashColor: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => cardController.toggleSelectCard(index),
                        child: cardController.selectedCard.contains(index)
                            ? Hero(
                                tag: "selected_$index",
                                child: CardBackSide(),
                              )
                            : CardBackSide(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                if (cardController.selectedCard.length == 3) {
                  Get.toNamed(AppRoutes.RESULT);
                }
              },
              child: Text(
                cardController.selectedCard.length == 3
                    ? "See Result"
                    : "${cardController.selectedCard.length}/ 3 selected",
                style: Get.theme.textTheme.bodyLarge,
              ),
            ),
            Spacer(),
            Row(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Created By Yell Htet Kyaw"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'mgyehtetkyaw@gmail.com',
                        );
                        await launchUrl(emailLaunchUri);
                      },
                      icon: Icon(Icons.email),
                    ),
                    IconButton(
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            "https://www.linkedin.com/in/yellhtetkyaw"));
                      },
                      icon: Icon(BoxIcons.bxl_linkedin),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await launchUrl(
                            Uri.parse("https://www.github.com/y3llkyaw"),
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      icon: Icon(BoxIcons.bxl_github),
                    ),
                  ],
                ),
                Text("Powered By Flutter"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardBackSide extends StatelessWidget {
  const CardBackSide({Key? key, this.width = 200.0}) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 5,
        ),
      ]),
      child: Image.asset(
        "assets/image/back.webp",
        width: width,
      ),
    );
  }
}
