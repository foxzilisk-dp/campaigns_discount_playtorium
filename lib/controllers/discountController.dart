import 'package:get/get.dart';

import '../models/campaignTypes.dart';
import '../models/cartItems.dart';

class DiscountController extends GetxController {
  // Reactive list of cart items and campaigns
  var cartItems = <CartItem>[].obs;
  var campaigns = <Campaign>[].obs;

  // Reactive variable for selected campaign
  var selectedCampaign = Rx<Campaign?>(null);

  // Variables for total price before and after discount
  var totalPrice = 0.0.obs;
  var discountedPrice = 0.0.obs;

  // Method to calculate total price with discounts
  void calculateTotalPrice() {
    double total = 0.0; // Initialize total price

    // Calculate the total price of all cart items
    for (var item in cartItems) {
      total = total + item.price; // Full equation for total
    }

    // Set the total price before discount
    totalPrice.value = total;

    // Apply discount if a valid campaign is selected
    if (selectedCampaign.value != null &&
        validateCampaigns(selectedCampaign.value!)) {
      var campaign = selectedCampaign.value!;

      // Apply coupon-based discounts
      if (campaign.type == CampaignType.coupon) {
        if (campaign.subType == 'Fixed Amount') {
          double discountAmount = campaign.amount ?? 0.0;
          total =
              total - discountAmount; // Full equation for fixed amount discount
        } else if (campaign.subType == 'Percentage Discount') {
          double percentageDiscount =
              (total * (campaign.percentage ?? 0.0)) / 100;
          total = total -
              percentageDiscount; // Full equation for percentage discount
        }
      }

      // Apply onTop-based discounts
      else if (campaign.type == CampaignType.onTop) {
        if (campaign.subType == 'Discount by Points') {
          double pointsDiscount = (campaign.points ?? 0).toDouble();
          total = total - pointsDiscount; // Full equation for points discount
        } else if (campaign.subType == 'Percentage Discount by Item Category') {
          // Apply category-based percentage discount (example: clothing category)
          double categoryDiscount = 0.0;
          for (var item in cartItems) {
            if (item.category == campaign.category) {
              categoryDiscount +=
                  (item.price * (campaign.percentage ?? 0.0)) / 100;
            }
          }
          total =
              total - categoryDiscount; // Full equation for category discount
        }
      }

      // Apply Seasonal discount with thresholdAmount and thresholdDiscount
      for (var seasonal in campaigns
          .where((campaign) => campaign.type == CampaignType.seasonal)) {
        // Check if seasonal campaign has thresholdAmount and thresholdDiscount
        if (seasonal.thresholdAmount != null &&
            seasonal.thresholdDiscount != null) {
          // Check if the total meets the thresholdAmount to apply discount
          if (total >= seasonal.thresholdAmount!) {
            total -=
                seasonal.thresholdDiscount!; // Subtract the seasonal discount
          }
        }
      }
    }

    // Set the discounted price (ensuring it's not negative)
    discountedPrice.value = total.clamp(0, double.infinity);
  }

  // Validate if the selected campaign can be applied
  bool validateCampaigns(Campaign campaign) {
    // Check if the campaign is valid based on its type and parameters
    if (campaign.type == CampaignType.coupon) {
      if (campaign.subType == 'Fixed Amount' &&
          (campaign.amount == null || campaign.amount! <= 0)) {
        return false; // Fixed amount must be positive
      }
      if (campaign.subType == 'Percentage Discount' &&
          (campaign.percentage == null ||
              campaign.percentage! <= 0 ||
              campaign.percentage! > 100)) {
        return false; // Percentage discount must be between 0 and 100
      }
    }

    if (campaign.type == CampaignType.onTop) {
      if (campaign.subType == 'Discount by Points' &&
          (campaign.points == null || campaign.points! <= 0)) {
        return false; // Points discount must be positive
      }
      if (campaign.subType == 'Percentage Discount by Item Category' &&
          (campaign.percentage == null ||
              campaign.percentage! <= 0 ||
              campaign.percentage! > 100)) {
        return false; // Category discount must be between 0 and 100
      }
    }

    if (campaign.type == CampaignType.seasonal) {
      if (campaign.thresholdAmount == null ||
          campaign.thresholdDiscount == null) {
        return false; // Seasonal campaign must have valid thresholdAmount and thresholdDiscount
      }
    }

    return true; // Campaign is valid
  }

  // Reset the selections and clear calculations
  void reset() {
    selectedCampaign.value = null; // Reset selected campaign
    totalPrice.value = 0.0; // Reset total price
    discountedPrice.value = 0.0; // Reset discounted price
  }
}
