class Format {
  static String formatCurrency(dynamic price) {
    if (price == null) return "0 đ";
    String priceStr = price.toStringAsFixed(0);
    return "${priceStr.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ";
  }
}
