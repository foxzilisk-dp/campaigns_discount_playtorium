import 'package:flutter/material.dart';
import '../models/cartItems.dart';
import '../models/campaignTypes.dart';

class DiscountScreen extends StatelessWidget {
  /// List of cart items
  final List<CartItem> items = [
    CartItem(name: 'T-Shirt', price: 350, category: 'Clothing'),
    CartItem(name: 'Hat', price: 250, category: 'Accessories'),
    CartItem(name: 'Belt', price: 230, category: 'Accessories'),
  ];

  /// Sample campaigns discounts
  final List<Campaign> campaigns = [
    Campaign(type: CampaignType.coupon, subType: 'fixed', amount: 50),
    Campaign(type: CampaignType.onTop, subType: 'points', points: 68),
    Campaign(
      type: CampaignType.seasonal,
      subType: 'threshold',
      thresholdAmount: 300, // For every 300 THB...
      discountPerThreshold: 40, // ...give 40 THB off
    ),
  ];

  DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Display the list of items in the cart
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(items[index].name),
                        subtitle: Text(
                          '${items[index].price} THB (${items[index].category})',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
