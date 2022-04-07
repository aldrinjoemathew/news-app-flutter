extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension StringNumericCheck on String? {
  bool isInteger() {
    if (this == null) {
      return false;
    }
    return int.tryParse(this!) != null;
  }
}