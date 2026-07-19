import 'package:flutter/material.dart';

/// Border radius tokens ported from `--ig-radius-*`.
abstract final class IgRadii {
  static const lg = 12.0;
  static const md = 8.0;
  static const sm = 6.0;

  static const rLg = BorderRadius.all(Radius.circular(lg));
  static const rMd = BorderRadius.all(Radius.circular(md));
  static const rSm = BorderRadius.all(Radius.circular(sm));
}
