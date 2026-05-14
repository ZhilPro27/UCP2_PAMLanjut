import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
class LoadingSkeleton extends StatelessWidget {
  final int count;
  final double height;
  final EdgeInsetsGeometry padding;

  const LoadingSkeleton({
    super.key,
    this.count = 5,
    this.height = 80.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: count,
      itemBuilder: (context, index) {
        return Container(
          height: height,
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.muted.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }
}
