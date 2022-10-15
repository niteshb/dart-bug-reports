abstract class GenerateObjectFromString {
  static T fromString<T>(String s) {
    throw UnimplementedError();
  }
}

T? genericFunction<T extends GenerateObjectFromString>(String s) {
  print(T.runtimeType); // Type

  // Compile ERROR: in the following line
  // The method 'fromString' isn't defined for the type 'Type'.
  // Try correcting the name to the name of an existing method, or defining a method named 'fromString'.
  //return T.fromString(s);
  // shouldn't this be compiling & dynamically binding to "T's" static method
}

class MyClass1 extends GenerateObjectFromString {
  late int i;
  MyClass1(this.i);
  static MyClass1 fromString(String s) {
    return MyClass1(int.parse(s));
  }

  @override
  String toString() => '{ i: $i }';
}

class MyClass2 extends GenerateObjectFromString {
  late double d;
  MyClass2(this.d);
  static MyClass2 fromString(String s) {
    return MyClass2(double.parse(s));
  }

  @override
  String toString() => '{ d: $d }';
}

void main(List<String> args) {
  print(MyClass1.fromString('5'));
  print(MyClass2.fromString('7.5'));
  var ii = genericFunction<MyClass1>('1');
  print('ii: $ii');
  var dd = genericFunction<MyClass2>('1.2');
  print('dd: $dd');
}
