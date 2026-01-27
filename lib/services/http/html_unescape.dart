final RegExp _entityPattern = RegExp(r'&(#x[0-9a-fA-F]+|#\d+|\w+);');

const Map<String, String> _namedEntities = {
  'quot': '"',
  'apos': "'",
  'amp': '&',
  'lt': '<',
  'gt': '>',
  'nbsp': ' ',
  'ldquo': '“',
  'rdquo': '”',
  'lsquo': '‘',
  'rsquo': '’',
};

String unescapeHtmlString(String input) {
  return input.replaceAllMapped(_entityPattern, (match) {
    final entity = match.group(1);
    if (entity == null) return match.group(0) ?? '';
    if (entity.startsWith('#x') || entity.startsWith('#X')) {
      final codePoint = int.tryParse(entity.substring(2), radix: 16);
      if (codePoint != null) {
        return String.fromCharCode(codePoint);
      }
    } else if (entity.startsWith('#')) {
      final codePoint = int.tryParse(entity.substring(1));
      if (codePoint != null) {
        return String.fromCharCode(codePoint);
      }
    }
    final named = _namedEntities[entity.toLowerCase()];
    return named ?? match.group(0) ?? '';
  });
}

dynamic unescapeHtmlValue(dynamic value) {
  if (value is String) {
    return unescapeHtmlString(value);
  }
  if (value is List) {
    return value.map(unescapeHtmlValue).toList();
  }
  if (value is Map) {
    return value.map((key, nestedValue) {
      return MapEntry(key, unescapeHtmlValue(nestedValue));
    });
  }
  return value;
}

Map<String, dynamic> unescapeHtmlMap(Map<String, dynamic> map) {
  return map.map((key, value) => MapEntry(key, unescapeHtmlValue(value)));
}
