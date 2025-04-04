
import 'package:flutter/material.dart';

// 带 token 的系统网络图片加载
class GMNetworkImage extends StatefulWidget {
  final String url;
  final String? localPath;      // 本地兜底图片路径
  final String? token;          // 鉴权 Token
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius; // 圆角配置
  final Widget? placeholder;     // 自定义加载占位符
  final Widget? errorWidget;     // 自定义错误提示

  const GMNetworkImage({
    super.key,
    required this.url,
    this.localPath,
    this.token,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<GMNetworkImage> createState() => _GMNetworkImageState();
}

class _GMNetworkImageState extends State<GMNetworkImage> {
  bool _hasError = false;
  bool _isLoading = true;

  // 获取自定义 Header（带 Token）
  Map<String, String> get _headers {
    return {
      if (widget.token != null)
        'Authorization': 'Bearer ${widget.token}'
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: _hasError ? _buildErrorWidget() : _buildNetworkImage(),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      headers: _headers,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        _isLoading = frame == null;
        if (wasSynchronouslyLoaded) {
          _isLoading = false;
          return child;
        }
        return _isLoading ? _buildPlaceholder() : child;
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('图片加载失败: url=${widget.url}, error=$error');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasError = true);
        });
        return const SizedBox.shrink(); // 错误时暂时隐藏，由外层处理
      },
    );
  }

  Widget _buildErrorWidget() {
    // 优先显示自定义错误组件
    if (widget.errorWidget != null) return widget.errorWidget!;

    // 其次尝试显示本地兜底图片
    if (widget.localPath != null) {
      return Image.asset(
        widget.localPath!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    // 默认错误提示
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  // 加载占位符
  Widget _buildPlaceholder() {
    return widget.placeholder ?? const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
