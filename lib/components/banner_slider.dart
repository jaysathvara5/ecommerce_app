import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});
  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> banners = [
    {
      "tag": "LIMITED OFFER",
      "title": "Big Billion Days",
      "subtitle": "Up to 80% OFF on Electronics",
      "gradient": [Color(0xFF2874F0), Color(0xFF1a5dc8)],
      "icon": Icons.flash_on,
    },
    {
      "tag": "NEW ARRIVALS",
      "title": "Fashion Week",
      "subtitle": "Trending styles at best prices",
      "gradient": [Color(0xFFFF6B35), Color(0xFFE53935)],
      "icon": Icons.checkroom,
    },
    {
      "tag": "SUPER DEAL",
      "title": "Home & Kitchen",
      "subtitle": "Min 40% OFF on top brands",
      "gradient": [Color(0xFF00897B), Color(0xFF00695C)],
      "icon": Icons.home,
    },
    {
      "tag": "EXCLUSIVE",
      "title": "Beauty & Health",
      "subtitle": "Premium products, budget prices",
      "gradient": [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
      "icon": Icons.spa,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      _currentPage = (_currentPage + 1) % banners.length;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final b = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: b['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(b['icon'], size: 130, color: Colors.white.withOpacity(0.12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(b['tag'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                          const SizedBox(height: 8),
                          Text(b['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(b['subtitle'], style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("Shop Now", style: TextStyle(color: (b['gradient'] as List)[0], fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentPage == i ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: _currentPage == i ? const Color(0xFF2874F0) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          )),
        ),
      ],
    );
  }
}
