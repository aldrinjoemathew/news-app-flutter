void main() {
  print("Hello World!");

  var a = 1;
  int ab = 12;
  const c = 12;
  final String name = "deena";
  // var result = fibonacci(10);
  // print("Fibonacci = " + result.toString());
  // 0 1 1 2 3
  // final result = calcNthFibonacci(10);
  // print("Nth fibonacci: " + result.toString());
  printWithDelay("printing after delay");
  print(tryCatch());
}

int tryCatch() {
  double value = 1;
  try {
    print(value + 3);
    return 0;
  } on IntegerDivisionByZeroException catch (e) {
    print("division by zero");
  } finally {
    print("finally");
    return 1;
  }

}

Future<void> printWithDelay(String msg) async {
  await Future.delayed(Duration(seconds: 1));
  print(msg);
}

int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int calcNthFibonacci(int n) {
  print("N: " + n.toString());
  var first = 0;
  var second = 1;
  var sum = 0;
  for (var i = 1; i < n; i++) {
    sum = first + second;
    first = second;
    second = sum;
  }
  return sum;
}

class NewsArticle {
  String title;
  String publishedAt;
  String description;
  String url;
  String urlToImage;
  String content;
  Source source;

  String getReadableDate() {
    return "Jan 08, 2021 at 01:00 pm";
  }
}

class Source {
  String id;
  String name;
}

class Reader {
  void read() {}
}

class KindleReader implements Reader {
  @override
  void read() {}
}
