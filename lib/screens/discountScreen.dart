import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/discountController.dart';
import '../models/cartItems.dart';
import '../models/campaignTypes.dart';

class DiscountScreen extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  DiscountScreen({super.key});

  // Load JSON data from assets
  Future<Map<String, dynamic>> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/sample_data.json');
    return json.decode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount Calculator')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadJsonData(), // Load JSON data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          final data = snapshot.data!;
          // Add cart items from JSON
          controller.cartItems.addAll((data['cartItems'] as List).map((item) {
            return CartItem(
              name: item['name'],
              price: item['price'].toDouble(),
              category: item['category'],
            );
          }).toList());

          // Add campaigns from JSON
          controller.campaigns
              .addAll((data['campaigns'] as List).map((campaign) {
            return Campaign(
              type: CampaignType.values.firstWhere(
                  (e) => e.toString() == 'CampaignType.${campaign['type']}'),
              subType: campaign['subType'],
              amount: campaign['amount']?.toDouble(),
              percentage: campaign['percentage']?.toDouble(),
              points: campaign['points'],
              category: campaign['category'],
              thresholdAmount: campaign['thresholdAmount']?.toDouble(),
              thresholdDiscount: campaign['thresholdDiscount']?.toDouble(),
            );
          }).toList());

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display total price
                Obx(() => Text(
                      'Total Price: ${controller.totalPrice.value.toStringAsFixed(2)} THB',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )),
                const SizedBox(height: 20),
                // Dropdown to select campaign
                DropdownButton<Campaign>(
                  hint: Text('Select a campaign'),
                  onChanged: (Campaign? selectedCampaign) {
                    if (selectedCampaign != null) {
                      controller.selectedCampaign.value = selectedCampaign;
                      controller.calculateTotalPrice();
                    }
                  },
                  items: controller.campaigns.map((Campaign campaign) {
                    return DropdownMenuItem<Campaign>(
                      value: campaign,
                      child: Text(campaign.subType),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text('Cart Items:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.cartItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.price} THB (${item.category})'),
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
