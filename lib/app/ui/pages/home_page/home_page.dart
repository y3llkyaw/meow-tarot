import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tarot/app/controllers/card_controller.dart';
import 'package:tarot/app/routes/app_routes.dart';
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
              return WebLayout();
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
        actions: [
          OutlinedButton(
            onPressed: () {
              cardController.selectedCard.clear();
              cardController.shuffleList();
            },
            child: Row(
              spacing: 20,
              children: [
                Text("shuffle"),
                Icon(Icons.shuffle),
              ],
            ),
          ),
          SizedBox(
            width: 100,
          )
        ],
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
          ],
        ),
      ),
    );
  }
}

class CardBackSide extends StatelessWidget {
  const CardBackSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        "assets/image/dummy/back.png",
      ),
    );
  }
}
