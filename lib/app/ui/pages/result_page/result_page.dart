import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tarot/app/controllers/card_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final cardController = Get.put(CardController());

  @override
  void initState() {
    super.initState();
    if (cardController.selectedCard.length != 3) {
      Get.offAllNamed("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Wait for cards to load and for 3 cards to be selected
        if (cardController.cards.isEmpty ||
            cardController.selectedCard.length < 3) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      children: cardController.selectedCard
                              .map<Widget>(
                                (cardIndex) => SizedBox(
                                    width: Get.width * 0.4,
                                    child: ResultCard(cardIndex: cardIndex)),
                              )
                              .toList() +
                          [DeveloperCard()]),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }),
      floatingActionButton: Align(
        alignment: Alignment.centerLeft,
        child: FloatingActionButton(
            child: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            }),
      ),
    );
  }
}

class ResultCard extends StatefulWidget {
  final int cardIndex;
  const ResultCard({Key? key, required this.cardIndex}) : super(key: key);
  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  final CardController cardController = Get.find<CardController>();
  FlipCardController flipController = FlipCardController();
  bool isFront = true;
  String cardTag = "";
  @override
  void initState() {
    super.initState();
    switch (cardController.selectedCard.indexOf(widget.cardIndex)) {
      case 0:
        cardTag = "The Past";
        break;
      case 1:
        cardTag = "The Present";
        break;
      case 2:
        cardTag = "The Future";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = cardController.cards[widget.cardIndex];
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: cardController.showResult.value ? 1.0 : 0.0,
      ),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: Get.width * 0.4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "selected_${widget.cardIndex}",
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 200,
                      // height: 300,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.transparent,
                        onTap: () {
                          flipController.flipcard();
                          setState(() {
                            isFront = !isFront;
                          });
                        },
                        child: FlipCard(
                          backWidget: Image(
                            image: AssetImage(
                                'assets/image/processed_${widget.cardIndex}.png'),
                            height: 300,
                            fit: BoxFit.fitHeight,
                          ),
                          frontWidget: Image(
                            image: AssetImage('assets/image/back.png'),
                            height: 300,
                            fit: BoxFit.fitHeight,
                          ),
                          controller: flipController,
                          rotateSide: RotateSide.left,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text Section
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 500),
                        opacity:
                            flipController.state?.isFront == true ? 0.0 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                card['name'] ?? "Card Name",
                                style: Get.theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (card['keywords'] != null) ...[
                              Text(
                                "Keywords",
                                style:
                                    Get.theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[200],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (card['keywords'] as List)
                                    .map((k) => k.toString().capitalize!)
                                    .join(', '),
                                style: Get.theme.textTheme.bodyLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (card['fortune_telling'] != null) ...[
                              Text(
                                "Fortune Telling",
                                style: Get.theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[200],
                                ),
                              ),
                              const SizedBox(height: 4),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 100,
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: (card['fortune_telling'] as List)
                                      .map<Widget>(
                                        (ft) => Text(
                                          "\t \t\u2022 ${ft.toString().capitalize!}",
                                          style: Get.theme.textTheme.bodyLarge,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.amber[200],
                                  side: BorderSide(color: Colors.amber[200]!),
                                ),
                                child: Text("More details"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        curve: Curves.easeInCirc,
                        duration: Duration(milliseconds: 500),
                        left: 10,
                        top: flipController.state?.isFront == true ? 130 : 300,
                        child: AnimatedOpacity(
                          opacity:
                              flipController.state?.isFront == true ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Column(
                            children: [
                              Text(
                                cardTag,
                                style: Get.textTheme.headlineLarge!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 142, 137, 122)),
                              ),
                              Text(
                                "click the cards to flip",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 142, 137, 122)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DeveloperCard extends StatefulWidget {
  // final int cardIndex;
  const DeveloperCard({
    Key? key,
  }) : super(key: key);
  @override
  State<DeveloperCard> createState() => _DeveloperCardState();
}

class _DeveloperCardState extends State<DeveloperCard> {
  final CardController cardController = Get.find<CardController>();
  FlipCardController flipController = FlipCardController();
  bool isFront = true;
  String cardTag = "The Developer";

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: cardController.showResult.value ? 1.0 : 0.0,
      ),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: Get.width * 0.4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "the-developer",
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 200,
                      // height: 300,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.transparent,
                        onTap: () {
                          flipController.flipcard();
                          setState(() {
                            isFront = !isFront;
                          });
                        },
                        child: FlipCard(
                          backWidget: Image(
                            image: AssetImage('assets/image/developer.png'),
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                          frontWidget: Image.asset(
                            'assets/image/back.png',
                            height: 300,
                            fit: BoxFit.fitHeight,
                          ),
                          controller: flipController,
                          rotateSide: RotateSide.left,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text Section
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 500),
                        opacity:
                            flipController.state?.isFront == true ? 0.0 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Yell Htet Kyaw (The Developer)",
                                style: Get.theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "\t\t\tFlutter developer passionate about building sleek, responsive, and user-friendly mobile and web apps.",
                              style: Get.theme.textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Keywords",
                              style: Get.theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[200],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Flutter: Firbase, GetX, REST API, Laravel\nFun, Handsome",
                              style: Get.theme.textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Contacts",
                              style: Get.theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[200],
                              ),
                            ),
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
                                        Uri.parse(
                                            "https://www.github.com/y3llkyaw"),
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
                            const SizedBox(height: 40),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        curve: Curves.easeInCirc,
                        duration: Duration(milliseconds: 500),
                        left: 10,
                        top: flipController.state?.isFront == true ? 130 : 300,
                        child: AnimatedOpacity(
                          opacity:
                              flipController.state?.isFront == true ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cardTag,
                                style: Get.textTheme.headlineMedium!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 142, 137, 122)),
                              ),
                              Text(
                                "click the cards to flip",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                    color: const Color.fromARGB(
                                        255, 142, 137, 122)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
