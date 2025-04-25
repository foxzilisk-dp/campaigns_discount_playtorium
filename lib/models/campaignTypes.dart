// Enum representing main types of discount campaigns
enum CampaignType { coupon, onTop, seasonal }

class Campaign {
  // The main type; coupon, onTop, or seasonal
  final CampaignType type;

  // The subtype of the campaign; 'fixed', 'percentage', 'points'
  final String subType;

  // A fixed amount discount (50 THB off the total cart)
  final double? amount;

  // A percentage discount (10% off)
  final double? percentage;

  // Number of points the user wants to use (1 point = 1 THB)
  final int? points;

  // The category the discount applies to (used in OnTop category discounts)
  final String? category;

  // For seasonal discounts: threshold amount to qualify for a discount step (every 300 THB)
  final double? thresholdAmount;

  // For seasonal discounts: discount applied for each threshold reached (40 THB off per 300 THB)
  final double? discountPerThreshold;

  // Constructor to initialize the campaign type
  Campaign({
    required this.type,
    required this.subType,
    this.amount,
    this.percentage,
    this.points,
    this.category,
    this.thresholdAmount,
    this.discountPerThreshold,
  });
}
