void main() {
  Future(funcThatThrows)
      // Future completes with an error:
      .then((_) => print("Won't reach here"))
      // Future completes with the same error:
      .whenComplete(whenComplete)
      // Future completes with the same error:
      .then((_) => print("Won't reach here"))
      // Error is handled here:
      .catchError(handleError);
}

int funcThatThrows() {
  print('funcThatThrows:: I will throw an Exception');
  throw Exception({'source': 'funcThatThrows', 'throw': false});
  //return 5;
}

double whenComplete() {
  print('funcWhenComplete:: Reaches here');
  return 20.22;
}

handleError(_) {
  print('handleError:: I am in');
}
/* Output
funcThatThrows:: I will throw an Exception
funcWhenComplete:: Reaches here
handleError:: I am in
*/
