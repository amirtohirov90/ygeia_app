import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ygeia_app/theme/colors.dart';
import 'package:ygeia_app/theme/typography.dart';

void main() {
  test('YgeiaColors constants are defined', () {
    expect(YgeiaColors.bgBase, isA<Color>());
    expect(YgeiaColors.accent, isA<Color>());
    expect(YgeiaColors.textPrimary, isA<Color>());
  });

  test('YgeiaTypography styles are defined', () {
    expect(YgeiaTypography.h1, isA<TextStyle>());
    expect(YgeiaTypography.body, isA<TextStyle>());
    expect(YgeiaTypography.caption, isA<TextStyle>());
  });
}
