/// 300030 -> '3000.30'
String formatKopecks(int kopecks) => (kopecks / 100).toStringAsFixed(2);

/// '3000,30' или '3000.30' -> 300030 (копейки). Если не число, вернёт null
int? rublesToKopecks(String text) {
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  if (value == null) return null;
  return (value * 100).round();
}
