import '../models/campaignTypes.dart';
import '../models/cartItems.dart';

class CalculateDiscountService {
  /// This method calculates the total price after applying the discounts.
  ///
  /// [items] - List of items in the cart with a price and category.
  /// [campaigns] - List of campaigns to be applied on the cart.
  ///
  /// Returns the total price after applying the discount.
  double calculateTotalPrice(List<CartItem> items, List<Campaign> campaigns) {
    // Calculate the total price of all items in the cart.
    // Iterable<T>.fold(initialValue, (previousValue, element) => operation)
    double total = items.fold(0, (sum, item) => sum + item.price);
    // double total = 0;
    // for (var item in items) {
    //   total = total + item.price;
    // }

    // Map the selected campaigns by type
    Map<CampaignType, Campaign?> selectedCampaigns = {
      CampaignType.coupon: null,
      CampaignType.onTop: null,
      CampaignType.seasonal: null,
    };

    // Loop through the campaigns and assign the first matching campaign for each type
    for (var c in campaigns) {
      if (selectedCampaigns[c.type] == null) {
        selectedCampaigns[c.type] = c;
      }
    }

    // Process Coupon Campaign
    final coupon = selectedCampaigns[CampaignType.coupon];
    if (coupon != null) {
      // If the coupon is of type 'fixed'
      if (coupon.subType == 'fixed' && coupon.amount != null) {
        // Ensure that amount is not null before applying the discount
        total = total - coupon.amount!; // Subtract the fixed amount
      }
      // If the coupon is of type 'percentage'
      else if (coupon.subType == 'percentage' && coupon.percentage != null) {
        // Ensure percentage is not null before applying the discount
        total = total -
            (total *
                (coupon.percentage! / 100)); // Subtract percentage discount
      }
    }

    // Process On Top Campaign
    final onTop = selectedCampaigns[CampaignType.onTop];
    if (onTop != null) {
      // If the 'onTop' campaign applies a discount to items of the selected category.
      if (onTop.subType == 'category' &&
          onTop.category != null &&
          onTop.percentage != null) {
        // Calculate the discount only for the items in the selected category
        double categoryDiscount = 0;
        for (var item in items) {
          if (item.category == onTop.category) {
            categoryDiscount += item.price * (onTop.percentage! / 100);
          }
        }
        total = total -
            categoryDiscount; // Subtract the calculated category discount
      }
      // If the 'onTop' campaign applies discount based on the user's points
      else if (onTop.subType == 'points' && onTop.points != null) {
        // Limit the discount to a maximum of 20% of the total price
        double maxDiscount = total * 0.2;
        double discount = onTop.points!.toDouble().clamp(
            0, maxDiscount); // Ensure the discount doesn't exceed the max limit
        total = total - discount; // Subtract the point-based discount
      }
    }

    // Process Seasonal Campaign
    final seasonal = selectedCampaigns[CampaignType.seasonal];
    if (seasonal != null &&
        seasonal.thresholdAmount != null &&
        seasonal.discountPerThreshold != null) {
      // Calculate how many times the threshold is exceeded based on the total price
      int times = (total / seasonal.thresholdAmount!).floor();
      // Apply the discount for each threshold crossed
      total = total -
          (times *
              seasonal.discountPerThreshold!); // Subtract seasonal discount
    }

    return total.clamp(
        0,
        double
            .infinity); // value.clamp(minValue, maxValue) The total should not be negative
  }
}
