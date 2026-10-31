import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'android_resource.g.dart';

@ExchangeableObject()
class AndroidResource_ {
  String name;

  String? defType;

  String? defPackage;

  AndroidResource_({required this.name, this.defType, this.defPackage});

  static AndroidResource_ anim({required String name, String? defPackage}) {
    return AndroidResource_(
        name: name, defType: "anim", defPackage: defPackage);
  }

  static AndroidResource_ layout({required String name, String? defPackage}) {
    return AndroidResource_(
        name: name, defType: "layout", defPackage: defPackage);
  }

  static AndroidResource_ id({required String name, String? defPackage}) {
    return AndroidResource_(name: name, defType: "id", defPackage: defPackage);
  }

  static AndroidResource_ drawable({required String name, String? defPackage}) {
    return AndroidResource_(
        name: name, defType: "drawable", defPackage: defPackage);
  }
}
