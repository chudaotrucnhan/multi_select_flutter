import 'package:flutter/material.dart';

extension BoxDecorationExtensions on BoxDecoration {
  BoxDecoration merge(BoxDecoration? other) {
    return BoxDecoration(
      color: color ?? other?.color,
      image: image ?? other?.image,
      border: border ?? other?.border,
      borderRadius: borderRadius ?? other?.borderRadius,
      boxShadow: boxShadow ?? other?.boxShadow,
      gradient: gradient ?? other?.gradient,
      backgroundBlendMode: backgroundBlendMode ?? other?.backgroundBlendMode,
      shape: shape != null
          ? shape
          : other?.shape != null
              ? other!.shape
              : BoxShape.rectangle,
    );
  }
}
