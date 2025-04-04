import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dio/dio.dart';

/*
 navigator?.push(FadeAnimationRoute(page: PhotoViewGalleryWidget(images: dynamicModel?.picUrls ?? [], index: index)));

 */

class PhotoViewGalleryWidget extends StatefulWidget {
  //List images = [];
  List<String>? images;
  int index = 0;
  String? heroTag;
  PageController? controller;
  bool isLocalPhoto;


  PhotoViewGalleryWidget(
      {Key? key,
      required this.images,
      this.index = 0,
        this.isLocalPhoto = false,
        this.controller,
      this.heroTag})
      : super(key: key) {
    controller = PageController(initialPage: index);
  }

  @override
  _PhotoViewGalleryWidgetState createState() => _PhotoViewGalleryWidgetState();
}

class _PhotoViewGalleryWidgetState extends State<PhotoViewGalleryWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  Widget _buildBottomSheetWidget(context,
      {required Widget child}) {
    return InkWell(
      onTap: () => saveImage(),
      child: child,
    );
  }

  saveImage() async {
    try {
      String downloadUrl = widget.images![currentIndex];
      String suffix = getFileName(downloadUrl);
      final cacheDirectory = await getApplicationCacheDirectory();
      final path = '${cacheDirectory.path}/download/$suffix';
      print('path: $path');
      await Dio().download(downloadUrl, path);
      await Gal.putImage(path, album: 'save');
    } catch (e) {
      print('error: $e');
    }
  }

  String getFileName(String url) {
    // 解析 URL
    Uri uri = Uri.parse(url);
    // 获取文件名带后缀
    String fileName = uri.pathSegments.last;

    // // 获取文件后缀（类型）
    // String fileExtension = fileName.split('.').last;
    //
    // print("文件名称: $fileName");       // 输出: 12c2aca29ea896a628be.jpg
    // print("文件后缀: $fileExtension");
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: widget.isLocalPhoto
                      ? FileImage(File(widget.images![index]))
                      :  NetworkImage(widget.images?[index] ?? ''),
                  heroAttributes: widget.heroTag != null
                      ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                      : null,
                );
              },
              itemCount: widget.images?.length,
              backgroundDecoration: null,
              pageController: widget.controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            //图片index显示
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex + 1}/${widget.images?.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Positioned(
              bottom: 40,
              right: 40,
              child: _buildBottomSheetWidget(context, child: const Icon(Icons.save, size: 20, color: Colors.white))
          )
        ],
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class FadeAnimationRoute extends PageRouteBuilder {
  final Widget page;

  FadeAnimationRoute({required this.page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              Animation<double> linearAnimation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(animation);

              return FadeTransition(
                opacity: linearAnimation,
                child: child,
              );
            });
}

// class FadeRoute extends PageRouteBuilder {
//   final Widget page;
//
//   FadeRoute({required this.page})
//       : super(
//           pageBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) =>
//               page,
//           transitionsBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child,
//           ) =>
//               FadeTransition(
//             opacity: animation,
//             child: child,
//           ),
//         );
// }
