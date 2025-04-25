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
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when back button is pressed
        return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Exit App'),
                  content: const Text('Are you sure you want to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Reset values and exit the app
                        controller.reset();
                        Navigator.of(context).pop(true);
                        SystemNavigator.pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                  ],
                );
              },
            ) ??
            false; // Return false if the user doesn't confirm
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF011529),
        appBar: AppBar(
          title: const Text('Shopping cart',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFFD52525), // Main theme color
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Trigger the back button press event
              SystemNavigator.pop();
            },
          ),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Cart Items:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.cartItems[index];
                        return ListTile(
                          title: Text(item.name,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            '${item.price} THB (${item.category})',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dropdown to select campaign
                  Obx(() => DropdownButton<Campaign>(
                        hint: const Text(
                          'Select a campaign',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: controller.selectedCampaign
                            .value, // Show the selected campaign
                        onChanged: (Campaign? selectedCampaign) {
                          if (selectedCampaign != null) {
                            controller.selectedCampaign.value =
                                selectedCampaign;
                            controller
                                .calculateTotalPrice(); // Recalculate price when new campaign is selected
                          }
                        },
                        dropdownColor: const Color(0xFFD52525),
                        items: controller.campaigns.map((Campaign campaign) {
                          return DropdownMenuItem<Campaign>(
                            value: campaign,
                            child: Text(
                              campaign.subType,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      )),

                  const SizedBox(height: 20),
                  // Reset Button
                  ElevatedButton(
                    onPressed: () {
                      controller.reset(); // Reset the price calculation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD52525), // Reset button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display total price
                  Obx(() => Text(
                        'Total Price: ${controller.discountedPrice.value.toStringAsFixed(2)} THB',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
