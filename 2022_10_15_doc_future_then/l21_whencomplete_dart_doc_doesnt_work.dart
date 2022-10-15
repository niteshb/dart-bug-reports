void main() {
  funcThatThrows()
      // Future completes with an error:
      .then((_) => print("Won't reach here"))
      // Future completes with the same error:
      .whenComplete(whenComplete)
      // Future completes with the same error:
      .then((_) => print("Won't reach here"))
      // Error is handled here:
      .catchError(handleError);
}

Future<int> funcThatThrows() {
  print('funcThatThrows:: I will throw an Exception');
  throw Exception({'source': 'funcThatThrows', 'throw': false});
  //return Future.value(5);
}

double whenComplete() {
  print('funcWhenComplete:: Reaches here');
  return 20.22;
}

handleError(_) {
  print('handleError:: I am in');
}
