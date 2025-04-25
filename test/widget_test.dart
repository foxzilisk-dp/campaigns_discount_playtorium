import 'package:campaigns_discount_playtorium/models/campaignTypes.dart';
import 'package:campaigns_discount_playtorium/models/cartItems.dart';
import 'package:campaigns_discount_playtorium/services/calculateDiscount.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final items = [
    CartItem(name: 'เสื้อ', price: 350, category: 'Clothing'),
    CartItem(name: 'หมวก', price: 250, category: 'Accessories'),
  ];

  test('Fixed amount coupon applies correctly', () {
    final campaigns = [
      Campaign(type: CampaignType.coupon, subType: 'fixed', amount: 100)
    ];
    final price =
        CalculateDiscountService().calculateTotalPrice(items, campaigns);
    expect(price, 500);
  });

  test('Points discount capped at 20%', () {
    final campaigns = [
      Campaign(type: CampaignType.onTop, subType: 'points', points: 500)
    ];
    final price =
        CalculateDiscountService().calculateTotalPrice(items, campaigns);
    expect(price, closeTo(480, 0.01)); // 600 - max 20% = 480
  });

  test('Invalid campaign type returns full price', () {
    final campaigns = [Campaign(type: CampaignType.coupon, subType: 'unknown')];
    final price =
        CalculateDiscountService().calculateTotalPrice(items, campaigns);
    expect(price, 600); // no discount applied
  });
}
