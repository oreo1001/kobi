bool readyToRequest (List<String> transcription) {

  print('readyToRequest : ');
  print(!transcription.contains(''));
  if (!transcription.contains('')) {
    return true;
  }
  else {
    return false;
  }
}

int countEmptyStrings(List<String> list) {
  int count = 0;
  for (String s in list) {
    if (s.isEmpty) {
      count++;
    }
  }
  return count;
}