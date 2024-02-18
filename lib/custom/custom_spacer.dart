import 'package:custom_render_objects/custom/custom_column.dart';
import 'package:flutter/material.dart';

// Кастомный спейсер потому что Spacer() дефолтный не будет работать с нашим кастомной колонкой который мы создали
// Будут отличаться ParentData поэтому создаем кастомный
class CustomSpacer extends ParentDataWidget<CustomColumnParentData> {
  final int flex;

  const CustomSpacer({super.key, super.child = const SizedBox.shrink(), this.flex = 1});

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is CustomColumnParentData);

    final CustomColumnParentData parentData = renderObject.parentData! as CustomColumnParentData;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      final target = renderObject.parent;

      if (target is RenderObject) {
        target.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomColumn;
}
