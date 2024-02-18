import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  const CustomColumn({super.children, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderCustomColumn();
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  // Если у детей не установить наш кастомный ParentData то будет ошибка
  // BoxParentData is not a subtype of type CustomColumnParentData in type cast
  // поэтому нужно пройтись по детям и установить тайп на кастомный
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  @override
  void performLayout() {
    size = _computeSize(isWet: true);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(isWet: false);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Допонительный метод с миксинов чтобы нам так же как при лайоуте не проходит по детям и рисовать
    defaultPaint(context, offset);
  }

  Size _computeSize({required bool isWet}) {
    double width = 0;
    double height = 0;
    int totalFlex = 0;

    RenderBox? child = firstChild;

    //  Проходимся по всем детям и определяем размеры
    while (child != null) {
      final CustomColumnParentData childParentData = child.parentData as CustomColumnParentData;
      final int childFlex = childParentData.flex ?? 0;
      if (childFlex > 0) {
        totalFlex += childFlex;
      } else {
        late final Size childSize;

        // Не рисуем а просто передаем размер если вызван только dryLayout
        if (isWet) {
          // Нужно вызвать этот метод чтобы получить доступ к size
          child.layout(BoxConstraints(maxWidth: constraints.maxWidth), parentUsesSize: true);
          childSize = child.size;
        } else {
          childSize = child.getDryLayout(constraints);
        }

        height += childSize.height;

        // Ширину указываем максимальную из всех детей
        width = max(width, childSize.width);
      }

      // Переходим к следуещему ребенку
      child = childParentData.nextSibling;
    }

    // Распределяем остальное место по кастомным спейсерам
    child = firstChild;
    final double availableHeight = max(constraints.maxHeight - height, 0);

    while (child != null) {
      final CustomColumnParentData childParentData = child.parentData as CustomColumnParentData;

      final int childFlex = childParentData.flex ?? 0;

      if (childFlex > 0) {
        final childHeight = availableHeight / totalFlex * childFlex;

        late final Size childSize;

        final flexConstraints = BoxConstraints(
          maxWidth: constraints.maxWidth,
          minHeight: childHeight,
          maxHeight: childHeight,
        );

        if (isWet) {
          child.layout(flexConstraints, parentUsesSize: true);
          childSize = child.size;
        } else {
          childSize = getDryLayout(flexConstraints);
        }

        height += childHeight;

        // Ширину указываем максимальную из всех детей
        width = max(width, childSize.width);
      }
      // Переходим к следуещему ребенку
      child = childParentData.nextSibling;
    }

    if (isWet) {
      child = firstChild;
      Offset childOffset = const Offset(0, 0);

      while (child != null) {
        final CustomColumnParentData childParentData = child.parentData as CustomColumnParentData;

        childParentData.offset = Offset(0, childOffset.dy);
        childOffset += Offset(0, child.size.height);
        // Переходим к следуещему ребенку
        child = childParentData.nextSibling;
      }
    }

    return Size(width, height);
  }
}
