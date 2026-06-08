// lib/core/utils/name_helper.dart

class NameHelper {
  static String maskName(String name) {
    if (name.isEmpty) return "Anonim";
    List<String> names = name.split(' ');
    String maskedName = names.map((n) {
      if (n.length <= 1) return n;
      return "${n[0]}***";
    }).join(' ');
    return maskedName;
  }
}