enum UpdatesType {
  day,
  week,
  month,
}

bool isValid(String name) {
  return UpdatesType.values.any((e) => e.name == name);
}

// in seconds
int getTimeByType(UpdatesType type) {
  switch (type.name) {
    case "day":
      return 24 * 60 * 60;
    case "week":
      return 7 * 24 * 60 * 60;
    case "month":
      return 30 * 7 * 24 * 60 * 60;
  }
  return 0;
}
