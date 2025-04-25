import 'package:campaigns_discount_playtorium/controllers/discountController.dart';
import 'package:campaigns_discount_playtorium/models/campaignTypes.dart';
import 'package:campaigns_discount_playtorium/models/cartItems.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DiscountController controller;

  setUp(() {
    controller = DiscountController();
  });

  // Success case
  test('Success case: Calculate discount with valid campaign', () {
    controller.cartItems.addAll([
      CartItem(name: 'Shirt', price: 350, category: 'Clothing'),
      CartItem(name: 'Hat', price: 250, category: 'Accessories'),
    ]);

    controller.selectedCampaign.value = Campaign(
      type: CampaignType.coupon,
      subType: 'Percentage Discount',
      percentage: 10.0, // 10% discount
    );

    controller.calculateTotalPrice();

    expect(controller.totalPrice.value, 600);
    expect(controller.discountedPrice.value, 540); // 10% discount applied
  });

  // Error case
  test('Error case: Invalid campaign (percentage discount > 100)', () {
    controller.cartItems.addAll([
      CartItem(name: 'Shirt', price: 350, category: 'Clothing'),
      CartItem(name: 'Hat', price: 250, category: 'Accessories'),
    ]);

    controller.selectedCampaign.value = Campaign(
      type: CampaignType.coupon,
      subType: 'Percentage Discount',
      percentage: 120.0, // Invalid percentage
    );

    controller.calculateTotalPrice();

    expect(controller.totalPrice.value, 600);
    expect(controller.discountedPrice.value, 600); // No discount applied
  });
}
