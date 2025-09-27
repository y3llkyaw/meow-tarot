class TarotCard {
  final String name;
  final int number;
  final String arcana;
  final String suit;
  final String img;
  final List<String> fortuneTelling;
  final List<String> keywords;
  final Map<String, List<String>> meanings; // keys: "light", "shadow"
  final String archetype;
  final String hebrewAlphabet;
  final String numerology;
  final String elemental;
  final String mythical;
  final List<String> questionsToAsk;

  const TarotCard({
    required this.name,
    required this.number,
    required this.arcana,
    required this.suit,
    required this.img,
    required this.fortuneTelling,
    required this.keywords,
    required this.meanings,
    required this.archetype,
    required this.hebrewAlphabet,
    required this.numerology,
    required this.elemental,
    required this.mythical,
    required this.questionsToAsk,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      name: json['name'],
      number: int.parse(json['number']),
      arcana: json['arcana'],
      suit: json['suit'],
      img: json['img'],
      fortuneTelling: List<String>.from(json['fortune_telling'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      meanings: (json['meanings'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
      archetype: json['Archetype'] ?? '',
      hebrewAlphabet: json['Hebrew Alphabet'] ?? '',
      numerology: json['Numerology'] ?? '',
      elemental: json['Elemental'] ?? '',
      mythical: json['Mythical/Spiritual'] ?? '',
      questionsToAsk: List<String>.from(json['Questions to Ask'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'arcana': arcana,
      'suit': suit,
      'img': img,
      'fortune_telling': fortuneTelling,
      'keywords': keywords,
      'meanings': meanings,
      'archetype': archetype,
      'hebrew_alphabet': hebrewAlphabet,
      'numerology': numerology,
      'elemental': elemental,
      'mythical': mythical,
      'questions_to_ask': questionsToAsk,
    };
  }
}
