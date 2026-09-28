import 'dart:async';

void main() async {
  runExercise1();
  runExercise2();
  runExercise3();
  runExercise4();
  await runExercise5();
}

// =============================================================================
// EXERCISE 1 Thực hành cấu trúc chương trình và khai báo biến.  
// =============================================================================
void runExercise1() {
  print("\n===== EXERCISE 1 =====");
  
  int age = 22;
  double height = 1.77;
  String name = "Dang Huynh Duc";
  bool isStudent = true;

  print("Name: $name");
  print("Age: $age");
  print("Height: $height meters");
  print("Is student: $isStudent");
  print("Next year, $name will be ${age + 1} years old.");
}

// =============================================================================
// EXERCISE 2 Làm việc với List, Set, Map và các toán tử (+, -, ==, &&, ? :).  
// =============================================================================
void runExercise2() {
  print("\n===== EXERCISE 2 =====");

  // 1. List & Arithmetic/Comparison operators
  List<int> numbers = [10, 20, 30, 40];
  numbers.add(50);
  int sum = numbers[0] + numbers[1];
  bool isGreater = numbers.last > numbers.first;

  print("Numbers list: $numbers");
  print("Sum of first two: $sum");
  print("Is last element greater than first: $isGreater");

  // 2. Set (Unique values)
  Set<String> categories = {"Flutter", "Dart", "Flutter"};
  categories.add("Mobile");
  categories.remove("Dart");
  print("Unique categories: $categories");

  // 3. Map (Key-Value)
  Map<String, dynamic> student = {
    "name": "Dang Huynh Duc   ",
    "age": 22,
    "major": "IT"
  };
  student["gpa"] = 3.8;
  print("Student info: $student");
  print("Major: ${student['major']}");

  // Ternary & Logical operator
  String status = (isGreater && numbers.length > 3) ? "Valid" : "Invalid";
  print("Status check: $status");
}

// =============================================================================
// EXERCISE 3 Áp dụng if/else, switch, vòng lặp và hàm.
// =============================================================================
void runExercise3() {
  print("\n===== EXERCISE 3 =====");

  // If/Else
  int score = 85;
  if (score >= 90) {
    print("Grade: A");
  } else if (score >= 80) { 
    print("Grade: B");
  } else {
    print("Grade: C");
  }

  // Switch Case
  int day = 3;
  switch (day) {
    case 1:
      print("Day: Monday");
      break;
    case 3:
      print("Day: Wednesday");
      break;
    default:
      print("Day: Weekend");
  }

  // Loops
  List<String> fruits = ["Apple", "Banana", "Cherry"];
  for (int i = 0; i < fruits.length; i++) {
    print("For loop: ${fruits[i]}");
  }
  for (var fruit in fruits) {
    print("For-in loop: $fruit");
  }
  fruits.forEach((fruit) => print("forEach: $fruit"));

  // Functions
  print("Area: ${calculateArea(5.0, 10.0)}");
  print("Product: ${multiply(4, 5)}");
}

double calculateArea(double w, double h) => w * h;
int multiply(int a, int b) => a * b;

// =============================================================================
// EXERCISE 4 Thực hành về lớp, đối tượng, hàm khởi tạo, kế thừa và ghi đè phương thức.
// =============================================================================
class Car {
  String brand;
  Car(this.brand);
  Car.unknown() : brand = "Generic";

  void drive() {
    print("The $brand car is driving.");
  }
}

class ElectricCar extends Car {
  double batteryCapacity;

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print("The $brand electric car is driving silently with $batteryCapacity kWh.");
  }
}

void runExercise4() {
  print("\n===== EXERCISE 4 =====");

  Car myCar = Car("Toyota");
  myCar.drive();

  Car unknownCar = Car.unknown();
  unknownCar.drive();

  ElectricCar myTesla = ElectricCar("Tesla", 75.0);
  myTesla.drive();
}

// =============================================================================
// EXERCISE 5 Làm việc với các tính năng bất đồng bộ của Dart.
// =============================================================================
Future<String> fetchData() async {
  await Future.delayed(Duration(milliseconds: 1000));
  return "Data loaded successfully.";
}

Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i;
  }
}

Future<void> runExercise5() async {
  print("\n===== EXERCISE 5 =====");

  // Async / Await
  print("Fetching data...");
  String result = await fetchData();
  print("Result: $result");

  // Null Safety
  String? nullableText;
  print("Default text: ${nullableText ?? 'Fallback value'}");
  nullableText = "Hello Dart";
  print("Text length: ${nullableText!.length}");

  // Stream
  print("Starting Stream...");
  await for (int value in countStream(3)) {
    print("Stream value: $value");
  }
  print("Stream completed.");
}