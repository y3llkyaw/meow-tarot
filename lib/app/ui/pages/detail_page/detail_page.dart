import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot/app/data/models/tarot_card.dart';

class DetailPage extends GetView {
  const DetailPage({Key? key, required this.card}) : super(key: key);
  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile
              return MobileLayout(
                card: card,
              );
            } else if (constraints.maxWidth < 1024) {
              // Tablet
              return MobileLayout(
                card: card,
                isWide: true,
              );
            } else {
              // Web / Desktop
              return MobileLayout(
                card: card,
                isWide: true,
              );
            }
          },
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key, required this.card, this.isWide = false})
      : super(key: key);

  final TarotCard card;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * (isWide ? 0.2 : 0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: "selected_${card.number}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/image/processed_${card.number}.webp",
                        width: 260,
                        height: 360,
                        fit: BoxFit.fitHeight,
                        errorBuilder: (ctx, e, st) => Container(
                          width: 260,
                          height: 360,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${card.arcana} • #${card.number} • ${card.suit}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(card.elemental),
                      // backgroundColor: Colors.amber[200],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: 'Keywords'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: card.keywords
                      .map((k) => Chip(label: Text(k.toUpperCase())))
                      .toList(),
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: 'Fortune Telling'),
                ...card.fortuneTelling.map((f) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.star_border),
                      title: Text(f),
                    )),
                const SizedBox(height: 8),
                _SectionTitle(title: 'Meanings'),
                ExpansionTile(
                  title: Text('Light (Upright)'),
                  children: card.meanings['light']!
                      .map((s) => ListTile(
                            dense: true,
                            leading: Icon(Icons.check_circle_outline),
                            title: Text(s),
                          ))
                      .toList(),
                ),
                ExpansionTile(
                  title: Text('Shadow (Reversed)'),
                  children: card.meanings['shadow']!
                      .map((s) => ListTile(
                            dense: true,
                            leading: Icon(Icons.error_outline),
                            title: Text(s),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                _ListInfoRow(title: 'Archetype', value: card.archetype),
                _ListInfoRow(
                    title: 'Hebrew Alphabet', value: card.hebrewAlphabet),
                _ListInfoRow(title: 'Numerology', value: card.numerology),
                _ListInfoRow(
                    title: 'Mythical / Spiritual', value: card.mythical),
                const SizedBox(height: 16),
                _SectionTitle(title: 'Questions to Ask'),
                ...card.questionsToAsk.map((q) => ListTile(
                      dense: true,
                      leading: Icon(Icons.help_outline),
                      title: Text(q),
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.centerLeft,
        child: FloatingActionButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ListInfoRow extends StatelessWidget {
  final String title;
  final String value;
  const _ListInfoRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Example usage (for testing):
// MaterialApp(home: TarotCardDetailPage(card: sampleCard));
