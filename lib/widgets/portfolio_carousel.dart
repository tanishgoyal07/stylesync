import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PortfolioCarousel extends StatelessWidget {
  final String category;
  final List<String> images;

  const PortfolioCarousel({
    super.key,
    required this.category,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8D6E63),
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          items: images
              .map((image) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(image, fit: BoxFit.cover),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
