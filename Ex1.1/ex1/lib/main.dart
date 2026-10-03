// Lớp cha
class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void displayInfo() {
    print('Brand: $brand');
    print('Year: $year');
  }

  void move() {
    print('Vehicle is moving...');
  }
}

// Lớp con Car kế thừa Vehicle
class Car extends Vehicle {
  int numberOfDoors;

  Car(String brand, int year, this.numberOfDoors)
      : super(brand, year);

  @override
  void displayInfo() {
    print('Car');
    print('Brand: $brand');
    print('Year: $year');
    print('Number of doors: $numberOfDoors');
  }

  @override
  void move() {
    print('Car is driving...');
  }
}

// Lớp con Motorcycle kế thừa Vehicle
class Motorcycle extends Vehicle {
  bool hasHelmet;

  Motorcycle(String brand, int year, this.hasHelmet)
      : super(brand, year);

  @override
  void displayInfo() {
    print('Motorcycle');
    print('Brand: $brand');
    print('Year: $year');
    print('Has helmet: $hasHelmet');
  }

  @override
  void move() {
    print('Motorcycle is riding...');
  }
}

// Hàm main
void main() {
  print('========== VEHICLE SYSTEM ==========');

  // Tạo đối tượng Car
  Car car = Car('Toyota', 2024, 4);

  car.displayInfo();
  car.move();

  print('');

  // Tạo đối tượng Motorcycle
  Motorcycle motorcycle = Motorcycle('Honda', 2023, true);

  motorcycle.displayInfo();
  motorcycle.move();
}