import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:the/utils/values/dimens.dart';

class Banners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> bannersUrl = [
      'assets/images/banners/sale-banner-1.jpg',
      'assets/images/banners/sale-banner-2.jpg',
      'assets/images/banners/sale-banner-3.jpg',
      'assets/images/banners/sale-banner-4.jpg',
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: CarouselSlider(
          items: bannersUrl
              .map(
                (url) => ClipRRect(
                  child: Image.asset(
                    url,
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      BorderRadius.circular(2 * AppDimens.BORDER_RADIUS),
                ),
              )
              .toList(),
          options: CarouselOptions(
            aspectRatio: 3 / 2,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 1,
            autoPlayAnimationDuration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }
}
