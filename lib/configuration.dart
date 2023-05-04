import 'dart:ui';

class HomePageConfiguration {
  final bool baseOption;
  final bool fundTransferOption;
  final bool rechargeOption;
  final bool shoppingOption;

  final bool search;

  HomePageConfiguration({
    this.baseOption = true,
    this.fundTransferOption = false,
    this.rechargeOption = false,
    this.shoppingOption = false,

    this.search = false,
  });

  @override
  String toString() {
    return 'HomePageConfiguration{baseOption: $baseOption, fundTransferOption: $fundTransferOption, '
        'rechargeOption: $rechargeOption, shoppingOption: $shoppingOption}';
  }
}

class TitleDecoration {
  final String label;
  final Color labelColor;
  final String logoPath;
  final Color bgColor;

  TitleDecoration({this.label, this.labelColor, this.logoPath, this.bgColor});

  @override
  String toString() {
    return 'TitleDecoration{label: $label, labelColor: $labelColor, logoPath: $logoPath, bgColor: $bgColor}';
  }
}
