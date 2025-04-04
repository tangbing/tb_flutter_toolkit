import 'package:flutter/material.dart';
import 'package:tb_flutter_toolkit/tb_flutter_toolkit.dart';

class PhotoViewWidget extends StatelessWidget {
  PhotoViewWidget({super.key});

  final List<String> urls = [
    'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
    'https://blurha.sh/12c2aca29ea896a628be.jpg',
    'https://loremflickr.com/100/100/music?lock=0',
    'https://loremflickr.com/100/100/music?lock=1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoViewWidget'),
      ),
      body: GridView.builder(
          itemCount: urls.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.9
          ), itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: gmImage(urls[index]),
          onTap: () {
            Navigator.of(context).push(FadeAnimationRoute(
                page: PhotoViewGalleryWidget(images: urls, index: index)));
          },
        );
      }),
    );
  }
}
