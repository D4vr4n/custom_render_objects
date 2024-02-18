import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Элемент который имеет одного child
class CustomBlur extends SingleChildRenderObjectWidget {
  const CustomBlur({super.child, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderCustomBlur();
}

// Наследуется от того же RenderBox но с дополнительным функционалом и миксинами
class RenderCustomBlur extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2);

    final RenderBox? child = this.child;

    if (child != null) {
      // Такой же метод сохранения только с custom layer
      canvas.saveLayer(offset & size, paint);
      context.paintChild(child, offset);
      canvas.restore();
    }
  }
}
