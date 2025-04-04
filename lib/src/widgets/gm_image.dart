import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 带 token 的第三方带缓存的图片加载

Widget gmImage(
  String? url, {
  String? localPath,
      String? token,
  double? width,
  double? height,
  BoxFit? fit = BoxFit.contain,
  BorderRadius? borderRadius,
}) {
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(0), // 设置圆角
    child: url == null || url.isEmpty
        ? (localPath == null
            ? const SizedBox.shrink()
            : Image.asset(
                localPath!,
                width: width,
                height: height,
                fit: fit,
              ))
        : CachedNetworkImage(
            imageUrl: url,
            width: width,
            httpHeaders: token == null ? null : {'Authorization': 'Bearer $token'},
            height: height,
            fit: fit,
            placeholder: (context, url) => const SizedBox.shrink(),
            errorWidget: (context, url, error) => localPath == null
                ? SizedBox.shrink()
                : Image.asset(
                    localPath!,
                    width: width,
                    height: height,
                    fit: fit,
                  ),
          ),
  );
}
