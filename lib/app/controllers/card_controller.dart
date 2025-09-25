import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CardController extends GetxController {
  var cardList = List.generate(22, (index) => index).obs;
  var selectedCard = [].obs;
  var isStarted = false.obs;
  var showResult = true.obs;
  var cards = [].obs;
  var position = 1.0.obs;
  var isRestarting = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    cardList.shuffle();
    final cardsJson = await rootBundle.loadString('assets/data/cards.json');
    final decoded = jsonDecode(cardsJson);
    if (decoded is Map && decoded['cards'] is List) {
      cards.value = decoded['cards'];
    } else {
      cards.value = [];
      log('cards.json does not contain a "cards" list');
    }
    log(cards.runtimeType.toString());
    log(cards[0].toString());
  }

  void shuffleList() {
    cardList.shuffle();
  }

  Future<void> restart() async {
    if (!isRestarting.value) {
      isRestarting.value = true;
      var temp = position.value;
      selectedCard.clear();
      await Future.delayed(Duration(milliseconds: 300));
      position.value = 0.0;
      await Future.delayed(Duration(milliseconds: 700));
      position.value = temp * -1;
      isRestarting.value = false;
    }
  }

  void toggleSelectCard(int id) {
    if (selectedCard.contains(id)) {
      selectedCard.remove(id);
    } else {
      if (selectedCard.length < 3) {
        selectedCard.add(id);
      }
    }
  }
}
