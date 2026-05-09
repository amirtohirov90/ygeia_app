import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _shopSiteUrl = 'https://ygeia.ru';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        title: Text(
          'Магазин',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) => _ProductCard(product: _products[index]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  Future<void> _buy(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final email = Uri.encodeComponent(user?.email ?? '');
    final planId = product['planId'] as String;
    final uri = Uri.parse('$_shopSiteUrl/pay?plan=$planId&uid=$uid&email=$email');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = product['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, size: 48, color: color),
                    const SizedBox(height: 8),
                    Text(
                      product['emoji'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'] as String,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product['subtitle'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF999999),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      product['price'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D6A4F),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      product['oldPrice'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF999999),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _buy(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Купить',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _products = [
  {
    'title': 'Базис',
    'subtitle': 'ЗОЖ и привычки',
    'price': '790 ₽',
    'oldPrice': '2 490 ₽',
    'color': const Color(0xFF2D6A4F),
    'emoji': '🌿',
    'planId': 'book_basis',
  },
  {
    'title': 'Ритм',
    'subtitle': 'Греческая эстетика',
    'price': '790 ₽',
    'oldPrice': '2 990 ₽',
    'color': const Color(0xFFE07A5F),
    'emoji': '🏛️',
    'planId': 'book_rhythm',
  },
  {
    'title': 'Дзен',
    'subtitle': 'Азиатская философия',
    'price': '790 ₽',
    'oldPrice': '2 990 ₽',
    'color': const Color(0xFF8D9EAD),
    'emoji': '☯️',
    'planId': 'book_rhythm', // замени на book_zen когда добавишь в plans.js
  },
  {
    'title': 'Калибр',
    'subtitle': 'Деньги и качество',
    'price': '790 ₽',
    'oldPrice': '3 490 ₽',
    'color': const Color(0xFF3D405B),
    'emoji': '💎',
    'planId': 'book_rhythm', // замени на book_calibr когда добавишь в plans.js
  },
];
