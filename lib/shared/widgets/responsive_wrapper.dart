import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool centerContent;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.maxContentWidth;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: context.responsivePadding,
    );

    Widget content = Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      padding: effectivePadding,
      child: child,
    );

    if (centerContent && context.isWeb) {
      content = Center(child: content);
    }

    return content;
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCrossAxisCount = crossAxisCount ?? context.gridColumns;
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? context.horizontalSpacing;
    final effectiveMainAxisSpacing = mainAxisSpacing ?? context.verticalSpacing;
    final effectivePadding = padding ?? EdgeInsets.all(context.responsivePadding);

    return Padding(
      padding: effectivePadding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: childAspectRatio ?? 0.8,
          crossAxisSpacing: effectiveCrossAxisSpacing,
          mainAxisSpacing: effectiveMainAxisSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool wrapOnMobile;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapOnMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    if (wrapOnMobile && context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.map((child) => Padding(
          padding: EdgeInsets.only(bottom: context.verticalSpacing / 2),
          child: child,
        )).toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? context.cardWidth;
    final effectivePadding = padding ?? EdgeInsets.all(context.responsivePadding);
    final effectiveMargin = margin ?? EdgeInsets.all(context.responsivePadding / 2);

    return Container(
      width: effectiveWidth,
      height: height,
      margin: effectiveMargin,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.borderRadius),
          child: Padding(
            padding: effectivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}