import 'package:flutter/material.dart';

class CategorySlider extends StatefulWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategorySlider({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  final Map<String, IconData> _categoryIcons = {
    'all': Icons.apps,
    'beauty': Icons.spa,
    'fragrances': Icons.local_florist,
    'furniture': Icons.chair,
    'groceries': Icons.local_grocery_store,
    'home-decoration': Icons.home,
    'kitchen-accessories': Icons.kitchen,
    'laptops': Icons.laptop,
    'mens-shirts': Icons.checkroom,
    'mens-shoes': Icons.directions_walk,
    'mens-watches': Icons.watch,
    'mobile-accessories': Icons.phone_android,
    'motorcycle': Icons.two_wheeler,
    'skin-care': Icons.face,
    'smartphones': Icons.smartphone,
    'sports-accessories': Icons.sports_basketball,
    'sunglasses': Icons.wb_sunny,
    'tablets': Icons.tablet,
    'tops': Icons.dry_cleaning,
    'vehicle': Icons.directions_car,
    'womens-bags': Icons.shopping_bag,
    'womens-dresses': Icons.checkroom,
    'womens-jewellery': Icons.diamond,
    'womens-shoes': Icons.directions_walk,
    'womens-watches': Icons.watch,
  };

  IconData _getIcon(String category) {
    return _categoryIcons[category.toLowerCase()] ?? Icons.category;
  }

  String _formatLabel(String category) {
    if (category == 'all') return 'All';
    return category.split('-').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final cat = widget.categories[index];
          final isSelected = cat == widget.selected;
          return GestureDetector(
            onTap: () => widget.onSelected(cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade100,
                      border: isSelected ? Border.all(color: const Color(0xFF2874F0), width: 2) : null,
                      boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2874F0).withOpacity(0.3), blurRadius: 8)] : [],
                    ),
                    child: Icon(_getIcon(cat), size: 22, color: isSelected ? Colors.white : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatLabel(cat),
                    style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
