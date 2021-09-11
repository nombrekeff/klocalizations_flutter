dynamic getValueFromPath(String jsonPath, Map<String, dynamic> jsonObject) {
  var parts = jsonPath.split(".");
  var length = parts.length;
  dynamic property = jsonObject;

  for (var i = 0; i < length; i++) {
    if (property != null) property = property[parts[i]];
  }

  return property;
}

String interpolate(
  String string, {
  Map<String, dynamic> params = const {},
}) {
  var keys = params.keys;
  var result = string;

  for (var key in keys) {
    result = result.replaceAll('{{$key}}', '${params[key]}');
  }

  return result;
}
