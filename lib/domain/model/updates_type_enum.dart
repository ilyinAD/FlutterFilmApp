enum UpdatesType {
  day,
  week,
  month,
}

bool isValid(String name) {
  return UpdatesType.values.any((e) => e.name == name);
}
