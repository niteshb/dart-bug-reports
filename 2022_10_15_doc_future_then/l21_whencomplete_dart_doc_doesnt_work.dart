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
/* Output
Unhandled exception:
Exception: {source: funcThatThrows, throw: false}
#0      funcThatThrows    l21_whencomplete_dart_doc_doesnt_work.dart:15
#1      main              l21_whencomplete_dart_doc_doesnt_work.dart:2
#2      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:297:19)
#3      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
*/
