import 'package:flutter/material.dart';

import 'bank_card_widget.dart';

/// Карусель банковских карт с точками-индикаторами под ней
class CardCarouselWidget extends StatefulWidget {
  final String cardNumber;
  final String cardHolder;
  final bool isDarkMode;

  const CardCarouselWidget({super.key, required this.cardNumber, required this.cardHolder, required this.isDarkMode});

  @override
  State<CardCarouselWidget> createState() => _CardCarouselWidgetState();
}

class _CardCarouselWidgetState extends State<CardCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentCardIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentCardIndex = index;
              });
            },
            children: [
              BankCardWidget(cardNumber: widget.cardNumber, cardHolder: widget.cardHolder, isDarkMode: widget.isDarkMode),
              BankCardWidget(cardNumber: '0000-0000-0000-0000', cardHolder: widget.cardHolder, isDarkMode: widget.isDarkMode),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Точки-индикаторы под картой
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentCardIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentCardIndex == index ? Colors.blueAccent : (widget.isDarkMode ? Colors.white24 : Colors.black12),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
