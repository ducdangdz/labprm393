import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/models/student_model.dart';
import 'package:lab9/models/note_item.dart';
import 'package:lab9/models/product_item.dart';
import 'package:lab9/main.dart';

void main() {
  group('Lab 9.1: Student Model JSON Tests', () {
    test('Student parses correctly from JSON', () {
      const jsonStr = '''
      {
        "id": 1,
        "name": "Nguyen Van An",
        "email": "annv@fpt.edu.vn",
        "major": "Software Engineering",
        "gpa": 3.85,
        "phone": "0912345678"
      }
      ''';
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final student = Student.fromJson(map);

      expect(student.id, 1);
      expect(student.name, 'Nguyen Van An');
      expect(student.email, 'annv@fpt.edu.vn');
      expect(student.major, 'Software Engineering');
      expect(student.gpa, 3.85);
      expect(student.phone, '0912345678');
    });

    test('Student encodes correctly to JSON', () {
      final student = Student(
        id: 2,
        name: 'Tran Thi Bich',
        email: 'bichtt@fpt.edu.vn',
        major: 'Information Assurance',
        gpa: 3.65,
        phone: '0923456789',
      );
      final json = student.toJson();
      expect(json['id'], 2);
      expect(json['name'], 'Tran Thi Bich');
      expect(json['email'], 'bichtt@fpt.edu.vn');
      expect(json['gpa'], 3.65);
    });
  });

  group('Lab 9.2: NoteItem Model JSON Tests', () {
    test('NoteItem parses and serializes correctly', () {
      final note = NoteItem(
        id: '101',
        title: 'Meeting Notes',
        content: 'Discuss sprint 9 deliverables',
        category: 'Work',
        createdAt: '2026-11-09 10:00',
      );
      final map = note.toJson();
      final fromJson = NoteItem.fromJson(map);

      expect(fromJson.id, '101');
      expect(fromJson.title, 'Meeting Notes');
      expect(fromJson.content, 'Discuss sprint 9 deliverables');
      expect(fromJson.category, 'Work');
      expect(fromJson.createdAt, '2026-11-09 10:00');
    });
  });

  group('Lab 9.3: ProductItem CRUD Model Tests', () {
    test('ProductItem parses, copies, and serializes correctly', () {
      final product = ProductItem(
        id: 1,
        name: 'MacBook Air M2',
        category: 'Laptop',
        price: 1099.0,
        quantity: 10,
        description: 'Apple M2 chip',
        updatedAt: '2026-11-09 12:00',
      );

      final updated = product.copyWith(price: 999.0, quantity: 8);
      expect(updated.id, 1);
      expect(updated.name, 'MacBook Air M2');
      expect(updated.price, 999.0);
      expect(updated.quantity, 8);

      final map = updated.toJson();
      final fromJson = ProductItem.fromJson(map);
      expect(fromJson.price, 999.0);
      expect(fromJson.quantity, 8);
    });
  });

  group('Lab 9: UI Navigation Smoke Test', () {
    testWidgets('App renders navigation destinations', (WidgetTester tester) async {
      await tester.pumpWidget(const Lab9App());
      await tester.pump();

      expect(find.text('9.1 Assets JSON'), findsOneWidget);
      expect(find.text('9.2 Local Storage'), findsOneWidget);
      expect(find.text('9.3 CRUD Mini DB'), findsOneWidget);
    });
  });
}
