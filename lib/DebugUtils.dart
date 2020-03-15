void printLongString(String longString) {
  while (longString.length > 0) {
    int initLength = (longString.length >= 500 ? 500 : longString.length);
    print(longString.substring(0, initLength));
    int endLength = longString.length;
    longString = longString.substring(initLength, endLength);
  }
}