import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_media_size.g.dart';

@ExchangeableObject()
class PrintJobMediaSize_ {
  final String id;

  final String? label;

  final int widthMils;

  final int heightMils;

  const PrintJobMediaSize_(
      {required this.id,
      required this.widthMils,
      required this.heightMils,
      this.label});

  static const UNKNOWN_PORTRAIT = const PrintJobMediaSize_(
      id: "UNKNOWN_PORTRAIT", widthMils: 1, heightMils: 0x7fffffff);

  static const UNKNOWN_LANDSCAPE = const PrintJobMediaSize_(
      id: "UNKNOWN_LANDSCAPE", widthMils: 0x7fffffff, heightMils: 1);

  static const ISO_A0 = const PrintJobMediaSize_(
      id: "ISO_A0", widthMils: 33110, heightMils: 46810);

  static const ISO_A1 = const PrintJobMediaSize_(
      id: "ISO_A1", widthMils: 23390, heightMils: 33110);

  static const ISO_A2 = const PrintJobMediaSize_(
      id: "ISO_A2", widthMils: 16540, heightMils: 23390);

  static const ISO_A3 = const PrintJobMediaSize_(
      id: "ISO_A3", widthMils: 11690, heightMils: 16540);

  static const ISO_A4 = const PrintJobMediaSize_(
      id: "ISO_A4", widthMils: 8270, heightMils: 11690);

  static const ISO_A5 =
      const PrintJobMediaSize_(id: "ISO_A5", widthMils: 5830, heightMils: 8270);

  static const ISO_A6 =
      const PrintJobMediaSize_(id: "ISO_A6", widthMils: 4130, heightMils: 5830);

  static const ISO_A7 =
      const PrintJobMediaSize_(id: "ISO_A7", widthMils: 2910, heightMils: 4130);

  static const ISO_A8 =
      const PrintJobMediaSize_(id: "ISO_A8", widthMils: 2050, heightMils: 2910);

  static const ISO_A9 =
      const PrintJobMediaSize_(id: "ISO_A9", widthMils: 1460, heightMils: 2050);

  static const ISO_A10 = const PrintJobMediaSize_(
      id: "ISO_A10", widthMils: 1020, heightMils: 1460);

  static const ISO_B0 = const PrintJobMediaSize_(
      id: "ISO_B0", widthMils: 39370, heightMils: 55670);

  static const ISO_B1 = const PrintJobMediaSize_(
      id: "ISO_B1", widthMils: 27830, heightMils: 39370);

  static const ISO_B2 = const PrintJobMediaSize_(
      id: "ISO_B2", widthMils: 19690, heightMils: 27830);

  static const ISO_B3 = const PrintJobMediaSize_(
      id: "ISO_B3", widthMils: 13900, heightMils: 19690);

  static const ISO_B4 = const PrintJobMediaSize_(
      id: "ISO_B4", widthMils: 9840, heightMils: 13900);

  static const ISO_B5 =
      const PrintJobMediaSize_(id: "ISO_B5", widthMils: 6930, heightMils: 9840);

  static const ISO_B6 =
      const PrintJobMediaSize_(id: "ISO_B6", widthMils: 4920, heightMils: 6930);

  static const ISO_B7 =
      const PrintJobMediaSize_(id: "ISO_B7", widthMils: 3460, heightMils: 4920);

  static const ISO_B8 =
      const PrintJobMediaSize_(id: "ISO_B8", widthMils: 2440, heightMils: 3460);

  static const ISO_B9 =
      const PrintJobMediaSize_(id: "ISO_B9", widthMils: 1730, heightMils: 2440);

  static const ISO_B10 = const PrintJobMediaSize_(
      id: "ISO_B10", widthMils: 1220, heightMils: 1730);

  static const ISO_C0 = const PrintJobMediaSize_(
      id: "ISO_C0", widthMils: 36100, heightMils: 51060);

  static const ISO_C1 = const PrintJobMediaSize_(
      id: "ISO_C1", widthMils: 25510, heightMils: 36100);

  static const ISO_C2 = const PrintJobMediaSize_(
      id: "ISO_C2", widthMils: 18030, heightMils: 25510);

  static const ISO_C3 = const PrintJobMediaSize_(
      id: "ISO_C3", widthMils: 12760, heightMils: 18030);

  static const ISO_C4 = const PrintJobMediaSize_(
      id: "ISO_C4", widthMils: 9020, heightMils: 12760);

  static const ISO_C5 =
      const PrintJobMediaSize_(id: "ISO_C5", widthMils: 6380, heightMils: 9020);

  static const ISO_C6 =
      const PrintJobMediaSize_(id: "ISO_C6", widthMils: 4490, heightMils: 6380);

  static const ISO_C7 =
      const PrintJobMediaSize_(id: "ISO_C7", widthMils: 3190, heightMils: 4490);

  static const ISO_C8 =
      const PrintJobMediaSize_(id: "ISO_C8", widthMils: 2240, heightMils: 3190);

  static const ISO_C9 =
      const PrintJobMediaSize_(id: "ISO_C9", widthMils: 1570, heightMils: 2240);

  static const ISO_C10 = const PrintJobMediaSize_(
      id: "ISO_C10", widthMils: 1100, heightMils: 1570);

  static const NA_LETTER = const PrintJobMediaSize_(
      id: "NA_LETTER", widthMils: 8500, heightMils: 11000);

  static const NA_GOVT_LETTER = const PrintJobMediaSize_(
      id: "NA_GOVT_LETTER", widthMils: 8000, heightMils: 10500);

  static const NA_LEGAL = const PrintJobMediaSize_(
      id: "NA_LEGAL", widthMils: 8500, heightMils: 14000);

  static const NA_JUNIOR_LEGAL = const PrintJobMediaSize_(
      id: "NA_JUNIOR_LEGAL", widthMils: 8000, heightMils: 5000);

  static const NA_LEDGER = const PrintJobMediaSize_(
      id: "NA_LEDGER", widthMils: 17000, heightMils: 11000);

  static const NA_TABLOID = const PrintJobMediaSize_(
      id: "NA_TABLOID", widthMils: 11000, heightMils: 17000);

  static const NA_INDEX_3X5 = const PrintJobMediaSize_(
      id: "NA_INDEX_3X5", widthMils: 3000, heightMils: 5000);

  static const NA_INDEX_4X6 = const PrintJobMediaSize_(
      id: "NA_INDEX_4X6", widthMils: 4000, heightMils: 6000);

  static const NA_INDEX_5X8 = const PrintJobMediaSize_(
      id: "NA_INDEX_5X8", widthMils: 5000, heightMils: 8000);

  static const NA_MONARCH = const PrintJobMediaSize_(
      id: "NA_MONARCH", widthMils: 7250, heightMils: 10500);

  static const NA_QUARTO = const PrintJobMediaSize_(
      id: "NA_QUARTO", widthMils: 8000, heightMils: 10000);

  static const NA_FOOLSCAP = const PrintJobMediaSize_(
      id: "NA_FOOLSCAP", widthMils: 8000, heightMils: 13000);

  static const ANSI_C = const PrintJobMediaSize_(
      id: "ANSI_C", widthMils: 17000, heightMils: 22000);

  static const ANSI_D = const PrintJobMediaSize_(
      id: "ANSI_D", widthMils: 22000, heightMils: 34000);

  static const ANSI_E = const PrintJobMediaSize_(
      id: "ANSI_E", widthMils: 34000, heightMils: 44000);

  static const ANSI_F = const PrintJobMediaSize_(
      id: "ANSI_F", widthMils: 28000, heightMils: 40000);

  static const NA_ARCH_A = const PrintJobMediaSize_(
      id: "NA_ARCH_A", widthMils: 9000, heightMils: 12000);

  static const NA_ARCH_B = const PrintJobMediaSize_(
      id: "NA_ARCH_B", widthMils: 12000, heightMils: 18000);

  static const NA_ARCH_C = const PrintJobMediaSize_(
      id: "NA_ARCH_C", widthMils: 18000, heightMils: 24000);

  static const NA_ARCH_D = const PrintJobMediaSize_(
      id: "NA_ARCH_D", widthMils: 24000, heightMils: 36000);

  static const NA_ARCH_E = const PrintJobMediaSize_(
      id: "NA_ARCH_E", widthMils: 36000, heightMils: 48000);

  static const NA_ARCH_E1 = const PrintJobMediaSize_(
      id: "NA_ARCH_E1", widthMils: 30000, heightMils: 42000);

  static const NA_SUPER_B = const PrintJobMediaSize_(
      id: "NA_SUPER_B", widthMils: 13000, heightMils: 19000);

  static const ROC_8K = const PrintJobMediaSize_(
      id: "ROC_8K", widthMils: 10629, heightMils: 15354);

  static const ROC_16K = const PrintJobMediaSize_(
      id: "ROC_16K", widthMils: 7677, heightMils: 10629);

  static const PRC_1 =
      const PrintJobMediaSize_(id: "PRC_1", widthMils: 4015, heightMils: 6496);

  static const PRC_2 =
      const PrintJobMediaSize_(id: "PRC_2", widthMils: 4015, heightMils: 6929);

  static const PRC_3 =
      const PrintJobMediaSize_(id: "PRC_3", widthMils: 4921, heightMils: 6929);

  static const PRC_4 =
      const PrintJobMediaSize_(id: "PRC_4", widthMils: 4330, heightMils: 8189);

  static const PRC_5 =
      const PrintJobMediaSize_(id: "PRC_5", widthMils: 4330, heightMils: 8661);

  static const PRC_6 =
      const PrintJobMediaSize_(id: "PRC_6", widthMils: 4724, heightMils: 12599);

  static const PRC_7 =
      const PrintJobMediaSize_(id: "PRC_7", widthMils: 6299, heightMils: 9055);

  static const PRC_8 =
      const PrintJobMediaSize_(id: "PRC_8", widthMils: 4724, heightMils: 12165);

  static const PRC_9 =
      const PrintJobMediaSize_(id: "PRC_9", widthMils: 9016, heightMils: 12756);

  static const PRC_10 = const PrintJobMediaSize_(
      id: "PRC_10", widthMils: 12756, heightMils: 18032);

  static const PRC_16K = const PrintJobMediaSize_(
      id: "PRC_16K", widthMils: 5749, heightMils: 8465);

  static const OM_PA_KAI = const PrintJobMediaSize_(
      id: "OM_PA_KAI", widthMils: 10512, heightMils: 15315);

  static const OM_DAI_PA_KAI = const PrintJobMediaSize_(
      id: "OM_DAI_PA_KAI", widthMils: 10827, heightMils: 15551);

  static const OM_JUURO_KU_KAI = const PrintJobMediaSize_(
      id: "OM_JUURO_KU_KAI", widthMils: 7796, heightMils: 10827);

  static const JIS_B10 = const PrintJobMediaSize_(
      id: "JIS_B10", widthMils: 1259, heightMils: 1772);

  static const JIS_B9 =
      const PrintJobMediaSize_(id: "JIS_B9", widthMils: 1772, heightMils: 2520);

  static const JIS_B8 =
      const PrintJobMediaSize_(id: "JIS_B8", widthMils: 2520, heightMils: 3583);

  static const JIS_B7 =
      const PrintJobMediaSize_(id: "JIS_B7", widthMils: 3583, heightMils: 5049);

  static const JIS_B6 =
      const PrintJobMediaSize_(id: "JIS_B6", widthMils: 5049, heightMils: 7165);

  static const JIS_B5 = const PrintJobMediaSize_(
      id: "JIS_B5", widthMils: 7165, heightMils: 10118);

  static const JIS_B4 = const PrintJobMediaSize_(
      id: "JIS_B4", widthMils: 10118, heightMils: 14331);

  static const JIS_B3 = const PrintJobMediaSize_(
      id: "JIS_B3", widthMils: 14331, heightMils: 20276);

  static const JIS_B2 = const PrintJobMediaSize_(
      id: "JIS_B2", widthMils: 20276, heightMils: 28661);

  static const JIS_B1 = const PrintJobMediaSize_(
      id: "JIS_B1", widthMils: 28661, heightMils: 40551);

  static const JIS_B0 = const PrintJobMediaSize_(
      id: "JIS_B0", widthMils: 40551, heightMils: 57323);

  static const JIS_EXEC = const PrintJobMediaSize_(
      id: "JIS_EXEC", widthMils: 8504, heightMils: 12992);

  static const JPN_CHOU4 = const PrintJobMediaSize_(
      id: "JPN_CHOU4", widthMils: 3543, heightMils: 8071);

  static const JPN_CHOU3 = const PrintJobMediaSize_(
      id: "JPN_CHOU3", widthMils: 4724, heightMils: 9252);

  static const JPN_CHOU2 = const PrintJobMediaSize_(
      id: "JPN_CHOU2", widthMils: 4374, heightMils: 5748);

  static const JPN_HAGAKI = const PrintJobMediaSize_(
      id: "JPN_HAGAKI", widthMils: 3937, heightMils: 5827);

  static const JPN_OUFUKU = const PrintJobMediaSize_(
      id: "JPN_OUFUKU", widthMils: 5827, heightMils: 7874);

  static const JPN_KAHU = const PrintJobMediaSize_(
      id: "JPN_KAHU", widthMils: 9449, heightMils: 12681);

  static const JPN_KAKU2 = const PrintJobMediaSize_(
      id: "JPN_KAKU2", widthMils: 9449, heightMils: 13071);

  static const JPN_YOU4 = const PrintJobMediaSize_(
      id: "JPN_YOU4", widthMils: 4134, heightMils: 9252);

  static const JPN_OE_PHOTO_L = const PrintJobMediaSize_(
      id: "JPN_OE_PHOTO_L", widthMils: 3500, heightMils: 5000);
}
