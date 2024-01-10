bool readyToRequest (List<String> transcription) {
  if (!transcription.contains('') && !transcription.contains('error')) {
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