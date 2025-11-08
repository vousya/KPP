class ShoppingItem {
  final String id;
  final String title;
  final String subtitle;
  final bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isPurchased,
  });

  ShoppingItem copyWith({bool? isPurchased}) {
    return ShoppingItem(
      id: id,
      title: title,
      subtitle: subtitle,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
