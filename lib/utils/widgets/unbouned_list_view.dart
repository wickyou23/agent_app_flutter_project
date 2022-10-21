import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UnboundedListView = ListView with UnboundedListViewMixin;
mixin UnboundedListViewMixin on ListView {
  @override
  Widget buildChildLayout(BuildContext context) {
    // TODO: support itemExtent
//    if (itemExtent != null) {
//      return UnboundedSliverFixedExtentList(
//        delegate: childrenDelegate,
//        itemExtent: itemExtent,
//      );
//    }
    return UnboundedSliverList(delegate: childrenDelegate);
  }

  @override
  @protected
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    // TODO: support shrinkWrap
//    if (shrinkWrap) {
//      return UnboundedShrinkWrappingViewport(
//        axisDirection: axisDirection,
//        offset: offset,
//        slivers: slivers,
//      );
//    }
    return UnboundedViewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
    );
  }

  @override
  List<Widget> buildSlivers(BuildContext context) {
    var sliver = buildChildLayout(context);
    var effectivePadding = padding;
    if (padding == null) {
      final mediaQuery = MediaQuery.maybeOf(context);
      if (mediaQuery != null) {
        // Automatically pad sliver with padding from MediaQuery.
        final mediaQueryHorizontalPadding =
            mediaQuery.padding.copyWith(top: 0, bottom: 0);
        final mediaQueryVerticalPadding =
            mediaQuery.padding.copyWith(left: 0, right: 0);
        // Consume the main axis padding with SliverPadding.
        effectivePadding = scrollDirection == Axis.vertical
            ? mediaQueryVerticalPadding
            : mediaQueryHorizontalPadding;
        // Leave behind the cross axis padding.
        sliver = MediaQuery(
          data: mediaQuery.copyWith(
            padding: scrollDirection == Axis.vertical
                ? mediaQueryHorizontalPadding
                : mediaQueryVerticalPadding,
          ),
          child: sliver,
        );
      }
    }

    if (effectivePadding != null) {
      sliver =
          UnboundedSliverPadding(padding: effectivePadding, sliver: sliver);
    }
    return <Widget>[sliver];
  }
}

class UnboundedSliverPadding = SliverPadding with UnboundedSliverPaddingMixin;
mixin UnboundedSliverPaddingMixin on SliverPadding {
  @override
  RenderSliverPadding createRenderObject(BuildContext context) {
    return UnboundedRenderSliverPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }
}

class UnboundedRenderSliverPadding = RenderSliverPadding
    with UnboundedRenderSliverPaddingMixin;
mixin UnboundedRenderSliverPaddingMixin on RenderSliverPadding {
  @override
  void performLayout() {
    super.performLayout();
    if (child?.geometry == null) {
      geometry = UnboundedSliverGeometry(
        existing: SliverGeometry.zero,
        crossAxisSize: 0,
      );
      return;
    }

    final childGeometry = child!.geometry! as UnboundedSliverGeometry;
    geometry = UnboundedSliverGeometry(
      existing: geometry,
      crossAxisSize: childGeometry.crossAxisSize + padding.vertical,
    );
  }
}

class UnboundedSliverList = SliverList with UnboundedSliverListMixin;
mixin UnboundedSliverListMixin on SliverList {
  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return UnboundedRenderSliverList(childManager: element);
  }
}

class UnboundedRenderSliverList extends RenderSliverList {
  UnboundedRenderSliverList({
    required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  // See RenderSliverList::performLayout
  @override
  void performLayout() {
    final constraints = this.constraints;
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0, '');
    final remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0, '');
    final targetEndScrollOffset = scrollOffset + remainingExtent;
    var childConstraints = constraints.asBoxConstraints();
    var leadingGarbage = 0;
    var trailingGarbage = 0;
    var reachedEnd = false;

    if (constraints.axis == Axis.horizontal) {
      childConstraints = childConstraints.copyWith(minHeight: 0);
    } else {
      childConstraints = childConstraints.copyWith(minWidth: 0);
    }

    var unboundedSize = 0;

    // should call update after each child is laid out
    void updateUnboundedSize(RenderBox? child) {
      if (child == null) {
        return;
      }
      unboundedSize = math.max(
        unboundedSize,
        constraints.axis == Axis.horizontal
            ? child.size.height.toInt()
            : child.size.width.toInt(),
      );
    }

    UnboundedSliverGeometry unboundedGeometry(SliverGeometry geometry) {
      return UnboundedSliverGeometry(
        existing: geometry,
        crossAxisSize: unboundedSize.toDouble(),
      );
    }

    // This algorithm in principle is straight-forward: find the first child
    // that overlaps the given scrollOffset, creating more children at the top
    // of the list if necessary, then walk down the list updating and laying out
    // each child and adding more at the end if necessary until we have enough
    // children to cover the entire viewport.
    //
    // It is complicated by one minor issue, which is that any time you update
    // or create a child, it's possible that the some of the children that
    // haven't yet been laid out will be removed, leaving the list in an
    // inconsistent state, and requiring that missing nodes be recreated.
    //
    // To keep this mess tractable, this algorithm starts from what is currently
    // the first child, if any, and then walks up and/or down from there, so
    // that the nodes that might get removed are always at the edges of what has
    // already been laid out.

    // Make sure we have at least one child to start from.
    if (firstChild == null) {
      if (!addInitialChild()) {
        // There are no children.
        geometry = unboundedGeometry(SliverGeometry.zero);
        childManager.didFinishLayout();
        return;
      }
    }

    // We have at least one child.

    // These variables track the range of children that we have laid out. Within
    // this range, the children have consecutive indices. Outside this range,
    // it's possible for a child to get removed without notice.
    RenderBox? leadingChildWithLayout;
    RenderBox? trailingChildWithLayout;
    var earliestUsefulChild = firstChild;

    // A firstChild with null layout offset is likely a result of children
    // reordering.
    //
    // We rely on firstChild to have accurate layout offset. In the case of null
    // layout offset, we have to find the first child that has valid layout
    // offset.
    if (childScrollOffset(firstChild!) == null) {
      var leadingChildrenWithoutLayoutOffset = 0;
      while (earliestUsefulChild != null &&
          childScrollOffset(earliestUsefulChild) == null) {
        earliestUsefulChild = childAfter(earliestUsefulChild);
        leadingChildrenWithoutLayoutOffset += 1;
      }
      // We should be able to destroy children with null layout offset safely,
      // because they are likely outside of viewport
      collectGarbage(leadingChildrenWithoutLayoutOffset, 0);
      // If can not find a valid layout offset, start from the initial child.
      if (firstChild == null) {
        if (!addInitialChild()) {
          // There are no children.
          geometry = unboundedGeometry(SliverGeometry.zero);
          childManager.didFinishLayout();
          return;
        }
      }
    }

    // Find the last child that is at or before the scrollOffset.
    earliestUsefulChild = firstChild;
    for (var earliestScrollOffset = childScrollOffset(earliestUsefulChild!)!;
        earliestScrollOffset > scrollOffset;
        earliestScrollOffset = childScrollOffset(earliestUsefulChild)!) {
      // We have to add children before the earliestUsefulChild.
      earliestUsefulChild =
          insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      updateUnboundedSize(earliestUsefulChild);
      if (earliestUsefulChild == null) {
        final _ = (firstChild!.parentData! as SliverMultiBoxAdaptorParentData)
          ..layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          // insertAndLayoutLeadingChild only lays out the children before
          // firstChild. In this case, nothing has been laid out. We have
          // to lay out firstChild manually.
          firstChild!.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          updateUnboundedSize(earliestUsefulChild);
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          // We ran out of children before reaching the scroll offset.
          // We must inform our parent that this sliver cannot fulfill
          // its contract and that we need a scroll offset correction.
          geometry = unboundedGeometry(
            SliverGeometry(
              scrollOffsetCorrection: -scrollOffset,
            ),
          );
          return;
        }
      }

      final firstChildScrollOffset =
          earliestScrollOffset - paintExtentOf(firstChild!);
      // firstChildScrollOffset may contain double precision error
      if (firstChildScrollOffset < -precisionErrorTolerance) {
        // Let's assume there is no child before the first child. We will
        // correct it on the next layout if it is not.
        geometry = unboundedGeometry(
          SliverGeometry(
            scrollOffsetCorrection: -firstChildScrollOffset,
          ),
        );
        final _ = (firstChild!.parentData! as SliverMultiBoxAdaptorParentData)
          ..layoutOffset = 0.0;
        return;
      }

      final _ = (earliestUsefulChild.parentData!
          as SliverMultiBoxAdaptorParentData)
        ..layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild, '');
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    assert(childScrollOffset(firstChild!)! > -precisionErrorTolerance, '');

    // If the scroll offset is at zero, we should make sure we are
    // actually at the beginning of the list.
    if (scrollOffset < precisionErrorTolerance) {
      // We iterate from the firstChild in case the leading child has a 0 paint
      // extent.
      while (indexOf(firstChild!) > 0) {
        final earliestScrollOffset = childScrollOffset(firstChild!)!;
        // We correct one child at a time. If there are more children before
        // the earliestUsefulChild, we will correct it once the scroll offset
        // reaches zero again.
        earliestUsefulChild =
            insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
        updateUnboundedSize(earliestUsefulChild);
        assert(earliestUsefulChild != null, '');
        final firstChildScrollOffset =
            earliestScrollOffset - paintExtentOf(firstChild!);
        final _ = (firstChild!.parentData! as SliverMultiBoxAdaptorParentData)
          ..layoutOffset = 0.0;
        // We only need to correct if the leading child actually has a
        // paint extent.
        if (firstChildScrollOffset < -precisionErrorTolerance) {
          geometry = unboundedGeometry(
            SliverGeometry(
              scrollOffsetCorrection: -firstChildScrollOffset,
            ),
          );
          return;
        }
      }
    }

    // At this point, earliestUsefulChild is the first child, and is a child
    // whose scrollOffset is at or before the scrollOffset, and
    // leadingChildWithLayout and trailingChildWithLayout are either null or
    // cover a range of render boxes that we have laid out with the first being
    // the same as earliestUsefulChild and the last being either at or after the
    // scroll offset.

    assert(earliestUsefulChild == firstChild, '');
    assert(childScrollOffset(earliestUsefulChild!)! <= scrollOffset, '');

    // Make sure we've laid out at least one child.
    if (leadingChildWithLayout == null) {
      earliestUsefulChild!.layout(childConstraints, parentUsesSize: true);
      updateUnboundedSize(earliestUsefulChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    // Here, earliestUsefulChild is still the first child, it's got a
    // scrollOffset that is at or before our actual scrollOffset, and it has
    // been laid out, and is in fact our leadingChildWithLayout. It's possible
    // that some children beyond that one have also been laid out.

    var inLayoutRange = true;
    var child = earliestUsefulChild;
    var index = indexOf(child!);
    var endScrollOffset = childScrollOffset(child)! + paintExtentOf(child);
    bool advance() {
      // returns true if we advanced, false if we have no more children
      // This function is used in two different places below, to avoid code duplication.
      assert(child != null, '');
      if (child == trailingChildWithLayout) {
        inLayoutRange = false;
      }
      child = childAfter(child!);
      if (child == null) {
        inLayoutRange = false;
      }
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child!) != index) {
          // We are missing a child. Insert it (and lay it out) if possible.
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          updateUnboundedSize(child);
          if (child == null) {
            // We have run out of children.
            return false;
          }
        } else {
          // Lay out the child.
          child!.layout(childConstraints, parentUsesSize: true);
          updateUnboundedSize(child);
        }
        trailingChildWithLayout = child;
      }
      assert(child != null, '');
      final childParentData = (child!.parentData!
          as SliverMultiBoxAdaptorParentData)
        ..layoutOffset = endScrollOffset;
      assert(childParentData.index == index, '');
      endScrollOffset = childScrollOffset(child!)! + paintExtentOf(child!);
      return true;
    }

    // Find the first child that ends after the scroll offset.
    while (endScrollOffset < scrollOffset) {
      leadingGarbage += 1;
      if (!advance()) {
        assert(leadingGarbage == childCount, '');
        assert(child == null, '');
        // we want to make sure we keep the last child around so we know the end scroll offset
        collectGarbage(leadingGarbage - 1, 0);
        assert(firstChild == lastChild, '');
        final extent =
            childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
        geometry = unboundedGeometry(
          SliverGeometry(
            scrollExtent: extent,
            maxPaintExtent: extent,
          ),
        );
        return;
      }
    }

    // Now find the first child that ends after our end.
    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    // Finally count up all the remaining children and label them as garbage.
    if (child != null) {
      child = childAfter(child!);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child!);
      }
    }

    // At this point everything should be good to go, we just have to clean up
    // the garbage and report the geometry.

    collectGarbage(leadingGarbage, trailingGarbage);

    assert(debugAssertChildListIsNonEmptyAndContiguous(), '');
    double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endScrollOffset,
      );
      assert(
        estimatedMaxScrollOffset >=
            endScrollOffset - childScrollOffset(firstChild!)!,
        '',
      );
    }
    final paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = unboundedGeometry(
      SliverGeometry(
        scrollExtent: estimatedMaxScrollOffset,
        paintExtent: paintExtent,
        cacheExtent: cacheExtent,
        maxPaintExtent: estimatedMaxScrollOffset,
        // Conservative to avoid flickering away the clip during scroll.
        hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint ||
            constraints.scrollOffset > 0.0,
      ),
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == endScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }
}

class UnboundedViewport = Viewport with UnboundedViewportMixin;
mixin UnboundedViewportMixin on Viewport {
  @override
  RenderViewport createRenderObject(BuildContext context) {
    return UnboundedRenderViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
    );
  }
}

class UnboundedRenderViewport = RenderViewport
    with UnboundedRenderViewportMixin;
mixin UnboundedRenderViewportMixin on RenderViewport {
  @override
  bool get sizedByParent => false;

  double _unboundedSize = double.infinity;

  @override
  void performLayout() {
    final constraints = this.constraints;
    if (axis == Axis.horizontal) {
      _unboundedSize = constraints.maxHeight;
      size = Size(constraints.maxWidth, 0);
    } else {
      _unboundedSize = constraints.maxWidth;
      size = Size(0, constraints.maxHeight);
    }

    super.performLayout();

    switch (axis) {
      case Axis.vertical:
        offset.applyViewportDimension(size.height);
        break;
      case Axis.horizontal:
        offset.applyViewportDimension(size.width);
        break;
    }
  }

  @override
  double layoutChildSequence({
    required RenderSliver? child,
    required double scrollOffset,
    required double overlap,
    required double layoutOffset,
    required double remainingPaintExtent,
    required double mainAxisExtent,
    required double crossAxisExtent,
    required GrowthDirection growthDirection,
    required RenderSliver? Function(RenderSliver child) advance,
    required double remainingCacheExtent,
    required double cacheOrigin,
  }) {
    var firstChild = child;
    final result = super.layoutChildSequence(
      child: child,
      scrollOffset: scrollOffset,
      overlap: overlap,
      layoutOffset: layoutOffset,
      remainingPaintExtent: remainingPaintExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: _unboundedSize,
      growthDirection: growthDirection,
      advance: advance,
      remainingCacheExtent: remainingCacheExtent,
      cacheOrigin: cacheOrigin,
    );

    var unboundedSize = 0;
    while (firstChild != null) {
      if (firstChild.geometry is UnboundedSliverGeometry) {
        final childGeometry = firstChild.geometry! as UnboundedSliverGeometry;
        unboundedSize =
            math.max(unboundedSize, childGeometry.crossAxisSize.toInt());
      }
      firstChild = advance(firstChild);
    }
    if (axis == Axis.horizontal) {
      size = Size(size.width, unboundedSize.toDouble());
    } else {
      size = Size(unboundedSize.toDouble(), size.height);
    }

    return result;
  }
}

class UnboundedSliverGeometry extends SliverGeometry {
  UnboundedSliverGeometry({
    SliverGeometry? existing,
    required this.crossAxisSize,
  }) : super(
          scrollExtent: existing?.scrollExtent ?? 0.0,
          paintExtent: existing?.paintExtent ?? 0.0,
          paintOrigin: existing?.paintOrigin ?? 0.0,
          layoutExtent: existing?.layoutExtent,
          maxPaintExtent: existing?.maxPaintExtent ?? 0.0,
          maxScrollObstructionExtent:
              existing?.maxScrollObstructionExtent ?? 0.0,
          hitTestExtent: existing?.hitTestExtent,
          visible: existing?.visible,
          hasVisualOverflow: existing?.hasVisualOverflow ?? false,
          scrollOffsetCorrection: existing?.scrollOffsetCorrection,
          cacheExtent: existing?.cacheExtent,
        );

  final double crossAxisSize;
}
