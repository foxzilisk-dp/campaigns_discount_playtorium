// Enum to define the types of campaigns (Coupon, OnTop, Seasonal)
enum CampaignType { coupon, onTop, seasonal }

// This class represents a campaign with its parameters
class Campaign {
  final CampaignType type; // Type of the campaign (Coupon, OnTop, Seasonal)
  final String subType; // Subtype of the campaign (fixed, percentage)
  final double? amount; // Amount for fixed discount
  final double? percentage; // Percentage for discount
  final int? points; // Points for discount (for OnTop campaigns)
  final String? category; // Category for discounts (for OnTop campaigns)
  final double? thresholdAmount; // Threshold amount for seasonal campaigns
  final double? thresholdDiscount; // Discount amount for seasonal campaigns

  // Constructor to create a Campaign
  Campaign({
    required this.type,
    required this.subType,
    this.amount,
    this.percentage,
    this.points,
    this.category,
    this.thresholdAmount,
    this.thresholdDiscount,
  });
}
