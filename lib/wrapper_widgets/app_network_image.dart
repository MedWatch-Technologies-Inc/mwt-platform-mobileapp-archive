import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class AppNetworkImage extends StatefulWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final bool useCachedNetworkImage;
  final bool useWrapperUrl;
  final BoxFit? wrapperUrlFitType;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? imageResizeHeight;
  final int? imageResizeWidth;
  int? imageUrlHeight;
  int? imageUrlWidth;

  AppNetworkImage({
    Key? key,
    this.imageUrl,
    this.fit,
    this.errorWidget,
    this.placeholder,
    this.height,
    this.width,
    this.memCacheWidth,
    this.memCacheHeight,
    this.imageResizeHeight,
    this.imageResizeWidth,
    this.useCachedNetworkImage = true,
    this.useWrapperUrl = false,
    this.wrapperUrlFitType,
  }) : super(key: key) {
    if (imageResizeHeight == null || imageResizeWidth == null) {
      imageUrlHeight = 700;
      imageUrlWidth = 700;
    } else {
      imageUrlHeight = imageResizeHeight;
      imageUrlWidth = imageResizeWidth;
    }
  }

  @override
  _AppNetworkImageState createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  @override
  Widget build(BuildContext context) {
    String fitType;
    switch (widget.wrapperUrlFitType ?? widget.fit ?? BoxFit.none) {
      case BoxFit.cover:
        fitType = 'cover';
        break;
      case BoxFit.scaleDown:
        fitType = 'scale-down';
        break;
      case BoxFit.contain:
      default:
        fitType = 'contain';
        break;
    }
    var extendedUrl =
        'https://img.cdn4dd.com/cdn-cgi/image/fit=$fitType,width=${widget.imageUrlWidth.toString()},height=${widget.imageUrlHeight.toString()},format=auto/';
    if (widget.useCachedNetworkImage) {
      return CachedNetworkImage(
        imageUrl: widget.useWrapperUrl
            ? extendedUrl + widget.imageUrl!
            : widget.imageUrl!,
        fit: widget.fit,
        placeholder: (context, value) {
          return widget.placeholder!;
        },
        errorWidget: (context, value, i) {
          return widget.errorWidget!;
        },
        height: widget.height,
        width: widget.width,
        memCacheWidth: widget.memCacheWidth,
        memCacheHeight: widget.memCacheHeight,
      );
    } else {
      return Image.network(
        widget.useWrapperUrl ? extendedUrl + widget.imageUrl! : widget.imageUrl!,
        fit: widget.fit,
        errorBuilder: (context, value, i) {
          return widget.errorWidget!;
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return widget.placeholder!;
        },
        height: widget.height,
        width: widget.width,
        cacheHeight: widget.memCacheWidth,
        cacheWidth: widget.memCacheHeight,
      );
    }
  }
}
