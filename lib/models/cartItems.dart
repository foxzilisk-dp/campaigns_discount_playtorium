// Represents a single item in the shopping cart.
class CartItem {
  // The name of the item ("T-Shirt", "Hat").
  final String name;

  // The price of the item in THB.
  final double price;

  // The category of the item ("Clothing", "Accessories").
  final String category;

  /// Creates a [CartItem] and all fields are required to ensure the [name], [price], and [category] are not NULL.
  CartItem({
    required this.name,
    required this.price,
    required this.category,
  });
}
