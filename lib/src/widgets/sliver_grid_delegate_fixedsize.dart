

import 'package:flutter/rendering.dart';

/*
作用：用GridView的时候 child在列表中所占大小宽高是一致的，但是往往我们需求不是的。
 */
class SliverGridDelegateWithFixedSize extends SliverGridDelegate {
  /// 宽
  final double width;

  /// 高
  final double height;

  /// 纵轴间距
  final double mainAxisSpacing;

  /// 横轴间距
  final double crossAxisSpacing;

  SliverGridDelegateWithFixedSize(this.width, this.height,
      {this.mainAxisSpacing = 0.0, this.crossAxisSpacing = 0.0});

  @override
  /*
  该方法负责根据给定的约束条件计算并返回一个 SliverGridLayout 实例
  1.根据约束条件和每个网格项目的宽度，计算出每行能够容纳的网格项目数量 crossAxisCount。
  2.根据横轴间距计算出实际的横轴间距 crossAxisSpacing，如果 crossAxisSpacing 为0，则根据剩余空间进行均匀分配。
  3.创建并返回一个 SliverGridRegularTileLayout 实例，其中包含了网格布局的各个参数，例如行列数量、主轴和横轴的间距以及每个网格项目的尺寸
   */
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisCount = constraints.crossAxisExtent ~/ width;
    final double crossAxisSpacing;
    if (this.crossAxisSpacing == 0.0) {
      crossAxisSpacing =
          (constraints.crossAxisExtent - width * crossAxisCount) /
              (crossAxisCount - 1);
    } else {
      crossAxisSpacing = this.crossAxisSpacing;
    }

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: height + mainAxisSpacing,
      crossAxisStride: width + crossAxisSpacing,
      childMainAxisExtent: height,
      childCrossAxisExtent: width,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  /*
  用于判断是否需要重新布局，即判断新旧代理是否有不同的属性值。
  如果 width、height 或 mainAxisSpacing 发生了变化，则返回 true，表示需要重新布局。
   */
  bool shouldRelayout(SliverGridDelegateWithFixedSize oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing;
  }
}
