class Book {
  final String id;
  final String title;
  final String pillar;
  final String subtitle;
  final String description;
  final int? priceCurrent;
  final int? priceOld;
  final bool available;
  final String accentColor;

  const Book({
    required this.id,
    required this.title,
    required this.pillar,
    required this.subtitle,
    required this.description,
    this.priceCurrent,
    this.priceOld,
    required this.available,
    required this.accentColor,
  });
}
