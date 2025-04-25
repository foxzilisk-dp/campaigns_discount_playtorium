import 'package:flutter/material.dart';
import 'package:get/get.dart';

// The main screen widget for calculating discounts
class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Discount Calculator')), // Top app bar with title
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Obx(() => Column(
              // Obx makes the UI update reactively when variables change
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align content to the start (left)
              children: [
                // More spacing
                ElevatedButton(
                  onPressed: () => {},
                  child: const Text("Calculate Final Price"),
                ),
                const SizedBox(height: 20),
                // Display the final calculated price
                const Text(
                  "Total Final Price: xx Baht",
                )
              ],
            )),
      ),
    );
  }
}
