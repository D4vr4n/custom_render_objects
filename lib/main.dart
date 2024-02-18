import 'package:custom_render_objects/custom/custom_blur.dart';
import 'package:custom_render_objects/custom/custom_circle.dart';
import 'package:custom_render_objects/custom/custom_column.dart';
import 'package:custom_render_objects/custom/custom_spacer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: CustomColumn(
            children: [
              CustomSpacer(),
              Center(
                child: SizedBox.square(
                  dimension: 100,
                  child: CustomCircles(color: Colors.black),
                ),
              ),
              CustomSpacer(),
              Center(
                child: CustomBlur(
                  child: Text(
                    'Custom Render Objects',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              CustomSpacer(),
            ],
          ),
        ),
      ),
    );
  }
}
