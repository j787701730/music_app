numFormat(num) {
  if (num != '') {
    if (num < 10000) {
      return '$num';
    } else if (num >= 10000 && num < 100000000) {
      return '${(num / 10000).floor()}万';
    } else {
      return '${(num / 100000000).floor()}亿';
    }
  } else {
    return '';
  }
}
