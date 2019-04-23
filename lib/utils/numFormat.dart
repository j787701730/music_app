numFormat(num) {
  if (num < 10000) {
    return num;
  } else if (num >= 10000 && num < 100000000) {
    return (num / 100000000).floor();
  }
}
