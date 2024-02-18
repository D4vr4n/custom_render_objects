import 'package:flutter/material.dart';

// Leaf как и само название означает конечный лист  в дереве, то есть элемент который не имеет дочерних узлов
class CustomCircles extends LeafRenderObjectWidget {
  const CustomCircles({required this.color, super.key});

  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderCustomCircles(color);

  @override
  void updateRenderObject(BuildContext context, RenderCustomCircles renderObject) {
    renderObject.color = color;
  }
}

class RenderCustomCircles extends RenderBox {
  RenderCustomCircles(Color color) : _color = color;

  Color _color;

  // Возможность изменить цвет в updateRenderObject
  // и чтобы у нас значение менялось при hot reload
  set color(Color value) {
    if (_color == value) return;

    _color = value;

    // Означает что нам нужно вызвать отрисовку
    markNeedsPaint();
  }

  // Означает что за размер будет отвечать родитель
  // Еще можно переопределить метод [performLayout()]
  @override
  bool get sizedByParent => true;

  // Вызывается перед самим layout методом
  // Ребенок должен возвращать какой размер хотел бы занять
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  // Здесь как и в CustomPaint переопределяется метод paint где мы рисуем то что нам нужно
  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()..color = _color;

    final mainRadius = size.shortestSide / 2;

    final Offset center = (offset + Offset(mainRadius, mainRadius));

    final double delta = mainRadius / 1.5;

    final double radius = mainRadius / 5;

    // save() и restore() методы отвечают за то чтобы использовать новый контекст (PaintingContext общий для всех виджетов в этом дереве)
    // context передается от родителя дальше к ребенку и от sibling'a к sibling'у
    canvas.save();

    canvas.translate(center.dx, center.dy);

    // Рисуем наши круги
    canvas.drawCircle(Offset(delta, 0), radius, paint);
    canvas.drawCircle(Offset(0, delta), radius, paint);
    canvas.drawCircle(Offset(-delta, 0), radius, paint);
    canvas.drawCircle(Offset(0, -delta), radius, paint);

    canvas.restore();
  }
}
