import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionStatus {
  final String planId;
  final bool isActive;
  final DateTime? expiresAt;

  SubscriptionStatus({
    required this.planId,
    required this.isActive,
    this.expiresAt,
  });

  bool get isClub => planId.startsWith('club');
  bool get isBook => planId.startsWith('book');

  String get planTitle {
    switch (planId) {
      case 'club_month':
        return 'Клуб ygeia · Месяц';
      case 'club_year':
        return 'Клуб ygeia · Год';
      case 'book_basis':
        return 'Книга «Базис»';
      case 'book_rhythm':
        return 'Книга «Ритм»';
      case 'book_zen':
        return 'Книга «Дзен»';
      case 'book_calibr':
        return 'Книга «Калибр»';
      default:
        return planId.isNotEmpty ? planId : 'Подписка';
    }
  }

  String get expiresLabel {
    if (expiresAt == null) return '';
    final d = expiresAt!;
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return 'до ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    return expiresAt!.difference(DateTime.now()).inDays <= 7;
  }
}

class SubscriptionService {
  static Future<SubscriptionStatus?> getSubscription() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      final data = doc.data() ?? {};
      final sub = data['subscription'] as Map<String, dynamic>?;
      if (sub == null) return null;

      final status = sub['status'] as String? ?? '';
      final expiresStr = sub['expiresAt'] as String?;
      final expiresAt =
          expiresStr != null ? DateTime.tryParse(expiresStr) : null;
      final isActive = status == 'active' &&
          (expiresAt == null || expiresAt.isAfter(DateTime.now()));

      return SubscriptionStatus(
        planId: sub['planId'] as String? ?? '',
        isActive: isActive,
        expiresAt: expiresAt,
      );
    } catch (_) {
      return null;
    }
  }
}
