class FiringTypeFormatter {
  static final FiringTypeFormatter _firingTypeFormatter = FiringTypeFormatter._internal();

  String format(String raw) {
    if (raw.length < 1) return raw;

    var firstChar = raw.substring(0, 1);

    return firstChar.toUpperCase() + raw.substring(1).toLowerCase();
  }

  factory FiringTypeFormatter() {
    return _firingTypeFormatter;
  }

  FiringTypeFormatter._internal();
}