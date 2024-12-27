import 'package:flutter/material.dart';

extension BoxDecorationExtensions on BoxDecoration {
  BoxDecoration merge(BoxDecoration? other) {
    return BoxDecoration(
        color: other?.color ?? color,
        image: other?.image ?? image,
        border: other?.border ?? border,
        borderRadius: other?.borderRadius ?? borderRadius,
        boxShadow: other?.boxShadow ?? boxShadow,
        gradient: other?.gradient ?? gradient,
        backgroundBlendMode: other?.backgroundBlendMode ?? backgroundBlendMode,
        shape: other?.shape ?? shape);
  }
}
