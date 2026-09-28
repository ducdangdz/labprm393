import 'dart:async';
import 'dart:convert';

void main() async {
  await exercise1();

  print('\n========== EXERCISE 2 ==========');
  await exercise2();

  print('\n========== EXERCISE 3 ==========');
  await exercise3();

  print('\n========== EXERCISE 4 ==========');
  await exercise4();

  print('\n========== EXERCISE 5 ==========');
  exercise5();
}

// ============================================================
// EXERCISE 1
// Product Model & Repository
// ============================================================

class Product {
  int id;
  String name;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}

class ProductRepository {
  final List<Product> _products = [
    Product(
      id: 1,
      name: 'Laptop',
      price: 1500.0,
    ),
    Product(
      id: 2,
      name: 'Mouse',
      price: 25.0,
    ),
    Product(
      id: 3,
      name: 'Keyboard',
      price: 50.0,
    ),
  ];

  // StreamController.broadcast() allows multiple listeners
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  // Return all products using Future
  Future<List<Product>> getAll() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return _products;
  }

  // Stream for newly added products
  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  // Add a new product
  void addProduct(Product product) {
    _products.add(product);

    // Send the new product to the stream
    _controller.add(product);
  }

  // Close StreamController
  void dispose() {
    _controller.close();
  }
}

Future<void> exercise1() async {
  print('========== EXERCISE 1 ==========');

  final repository = ProductRepository();

  // Listen for new products
  final subscription = repository.liveAdded().listen(
    (product) {
      print('New product added: $product');
    },
  );

  // Get all products
  final products = await repository.getAll();

  print('\nAll products:');

  for (final product in products) {
    print(product);
  }

  // Add Headphone
  repository.addProduct(
    Product(
      id: 4,
      name: 'Headphone',
      price: 80.0,
    ),
  );

  // Give Stream time to process event
  await Future.delayed(
    const Duration(milliseconds: 100),
  );

  await subscription.cancel();

  repository.dispose();
}

// ============================================================
// EXERCISE 2
// User Repository with JSON
// ============================================================

class User {
  String name;
  String email;

  User({
    required this.name,
    required this.email,
  });

  // Convert JSON data into User object
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

class UserRepository {
  // Simulate JSON data from API
  Future<List<User>> getUsers() async {
    const jsonData = '''
    [
      {
        "name": "John",
        "email": "john@gmail.com"
      },
      {
        "name": "Alice",
        "email": "alice@gmail.com"
      },
      {
        "name": "David",
        "email": "david@gmail.com"
      }
    ]
    ''';

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    // Convert JSON String to Dart List
    final List<dynamic> data = jsonDecode(jsonData);

    // Convert JSON objects into User objects
    final users = data
        .map(
          (item) => User.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return users;
  }
}

Future<void> exercise2() async {
  final repository = UserRepository();

  final users = await repository.getUsers();

  print('\nUsers from JSON:');

  for (final user in users) {
    print(user);
  }
}

// ============================================================
// EXERCISE 3
// Async + Microtask Debugging
// ============================================================

Future<void> exercise3() async {
  print('1. Start');

  // Microtask is added to the Microtask Queue
  scheduleMicrotask(() {
    print('3. Microtask');
  });

  // Future callback is added to the Event Queue
  Future(() {
    print('4. Future event');
  });

  print('2. End');

  // Wait for async operations to finish
  await Future.delayed(
    const Duration(milliseconds: 100),
  );
}

// ============================================================
// EXERCISE 4
// Stream Transformation
// ============================================================

Future<void> exercise4() async {
  final numberStream = Stream.fromIterable([
    1,
    2,
    3,
    4,
    5,
  ]);

  // map() calculates squares
  // where() keeps only even values
  final resultStream = numberStream
      .map(
        (number) => number * number,
      )
      .where(
        (number) => number % 2 == 0,
      );

  print('Even squares:');

  await for (final value in resultStream) {
    print(value);
  }
}

// ============================================================
// EXERCISE 5
// Factory Constructors & Cache
// ============================================================

class Settings {
  // Singleton instance
  static final Settings _instance = Settings._internal();

  // Private constructor
  Settings._internal();

  // Factory constructor
  factory Settings() {
    return _instance;
  }
}

void exercise5() {
  final a = Settings();
  final b = Settings();

  // Check whether a and b are the same object
  print('identical(a, b) = ${identical(a, b)}');
}