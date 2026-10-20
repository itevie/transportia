String formatIsoDate(String iso) {
  final date = DateTime.parse(iso);

  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}
