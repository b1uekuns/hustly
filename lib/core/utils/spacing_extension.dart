import 'package:flutter/material.dart';

extension ResponsiveSpacing on BuildContext {
  static const _baseWidth = 393.0;
  static const _baseHeight = 852.0;

  double get _screenWidth => MediaQuery.sizeOf(this).width;
  double get _screenHeight => MediaQuery.sizeOf(this).height;

  double _scaleW(double size) => size * _screenWidth / _baseWidth;
  double _scaleH(double size) => size * _screenHeight / _baseHeight;

  // SizedBox theo chiều ngang
  SizedBox hGap(double w) => SizedBox(width: _scaleW(w));

  // SizedBox theo chiều dọc
  SizedBox vGap(double h) => SizedBox(height: _scaleH(h));

  // EdgeInsets responsive
  EdgeInsets padAll(double v) => EdgeInsets.all(_scaleW(v));

  EdgeInsets padH(double h) => EdgeInsets.symmetric(horizontal: _scaleW(h));

  EdgeInsets padV(double v) => EdgeInsets.symmetric(vertical: _scaleH(v));

  EdgeInsets padSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: _scaleW(h), vertical: _scaleH(v));

  EdgeInsets padOnly({
    double l = 0,
    double r = 0,
    double t = 0,
    double b = 0,
  }) => EdgeInsets.only(
    left: _scaleW(l),
    right: _scaleW(r),
    top: _scaleH(t),
    bottom: _scaleH(b),
  );

  // Scale đơn lẻ
  double w(double size) => _scaleW(size);
  double h(double size) => _scaleH(size);
}
